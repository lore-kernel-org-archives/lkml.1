Return-Path: <linux-kernel-owner+w=401wt.eu-S1752542AbZFARuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbZFARuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 13:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750871AbZFARtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 13:49:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36905 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750985AbZFARtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 13:49:51 -0400
Date: Mon, 1 Jun 2009 18:49:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: paul@mad-scientist.net
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] coredump: Retry writes where appropriate
Message-ID: <20090601184934.1fc54411@lxorguk.ukuu.org.uk>
In-Reply-To: <1243877766.8547.38.camel@psmith-ubeta.netezza.com>
References: <1243748019.7369.319.camel@homebase.localnet>
	<20090531111851.07eb1df3@lxorguk.ukuu.org.uk>
	<20090601161234.GA10486@redhat.com>
	<1243877766.8547.38.camel@psmith-ubeta.netezza.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On the other hand, IMO all other signals, including SIGINT and SIGQUIT,
> should be ignored during core dumping.  Allowing SIGKILL gives a method
> for getting rid of core dumps in the relatively rare situation where
> people want/need to do so, and I don't see any real benefit to adding
> more signals to the list of things you can't do if you want robust
> cores.  Isn't one enough?

I also want usability. SIGINT/SIGQUIT are never sent except by user
requests to terminate a process so they can safely be allowed. If the
alternatives are the status quo or SIGKILL only then I'd favour the
status quo particularly having experienced the alternatives on some old
Unix systems.

Alan
