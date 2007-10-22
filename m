Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbXJVTTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbXJVTTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 15:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973AbXJVTSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 15:18:49 -0400
Received: from mail.queued.net ([207.210.101.209]:1818 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755964AbXJVTSs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 15:18:48 -0400
Date: Mon, 22 Oct 2007 15:18:45 -0400
From: Andres Salomon <dilinger@queued.net>
To: Florian Fainelli <florian.fainelli@telecomint.eu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4 resend] [x86] Add generic GPIO support to x86
Message-ID: <20071022151845.5874fba3@ephemeral>
In-Reply-To: <200710191401.56916.florian.fainelli@telecomint.eu>
References: <200710181551.24912.florian.fainelli@telecomint.eu>
	<20071018173828.159b15dd@ephemeral>
	<200710191401.56916.florian.fainelli@telecomint.eu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007 14:01:56 +0200
Florian Fainelli <florian.fainelli@telecomint.eu> wrote:

> Hi Andres,
> 
> Le jeudi 18 octobre 2007, Andres Salomon a écrit :
> > While I certainly would like to see a generic GPIO API, this one
> > isn't really useful for geode GPIOs.  It would be nice to have one
> > that did work for us as well.  Unfortunately, I haven't had the
> > chance to give much thought to this problem yet.
> 
> This one was discussed mostly on the ARM mailing-list and finally
> made his way to the mainline kernel. Though it lacks some functions
> to change for instance a entire GPIO line and not a single bit, it is
> used on ARM and MIPS systems so I would conform with this one for now
> because it is used by at least two or more architectures.

How does being used on MIPS and ARM make it suitable for x86?  If
you're arguing that other x86 platforms conform to it, and it might be
useful for them; sure, I'll buy that.  That doesn't seem to currently be
the case, though.
