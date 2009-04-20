Return-Path: <linux-kernel-owner+w=401wt.eu-S1754667AbZDTK3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbZDTK3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 06:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbZDTK2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 06:28:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46880 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751562AbZDTK2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 06:28:54 -0400
Date: Mon, 20 Apr 2009 11:29:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
Subject: Re: [console] CSI (128+27) vs BIG5 (and possibly others)
Message-ID: <20090420112937.78ec67d5@lxorguk.ukuu.org.uk>
In-Reply-To: <20090418210638.GU21409@const>
References: <20090418210638.GU21409@const>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Apr 2009 23:06:38 +0200
Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:

> Hello,
> 
> A chinese user reported that some characters don't show up fine on
> its console.  This happens to be because character 128+27 is handled
> specially by the linux Console.  I believe the same issues can happen
> with other characters sets.  Since linux' terminfo makes applications
> use \E[ anyway, would it be ok to add an option to disable the 128+27
> handling?

I'm reluctant to do so because its extra complication we don't need (at
least nobody has needed for over fifteen years), it's bound to confuse
some other application, and given almost everyone has already gone UTF-8
it's really debating a corner case only relevant to the past anyway.

Alan
