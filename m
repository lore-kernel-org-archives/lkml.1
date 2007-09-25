Return-Path: <linux-kernel-owner+w=401wt.eu-S1758273AbXIYPoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273AbXIYPoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 11:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755307AbXIYPn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 11:43:59 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59211 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755012AbXIYPn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 11:43:58 -0400
Date: Tue, 25 Sep 2007 16:48:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Newall <david@davidnewall.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Bill Davidsen <davidsen@tmr.com>,
       Philipp Marek <philipp@marek.priv.at>, 7eggert@gmx.de,
       majkls <majkls@prepere.com>, bunk@fs.tum.de,
       linux-kernel@vger.kernel.org
Subject: Re: Chroot bug
Message-ID: <20070925164806.4cadc6a5@the-village.bc.nu>
In-Reply-To: <46F92AAB.1060903@davidnewall.com>
References: <56705.193.171.152.61.1190289559.squirrel@webmail.marek.priv.at>
	<46F29A9A.4070806@davidnewall.com>
	<200709201817.17282@x5>
	<46F2B59F.8090709@davidnewall.com>
	<46F2DDD0.3030500@tmr.com>
	<46F380E4.4040606@davidnewall.com>
	<20070924213215.GA32716@vino.hallyn.com>
	<46F83474.5040503@davidnewall.com>
	<20070924230008.GA3160@vino.hallyn.com>
	<46F8BC8A.7080006@davidnewall.com>
	<20070925114947.GA9721@vino.hallyn.com>
	<46F91417.9050600@davidnewall.com>
	<46F924E3.50205@davidnewall.com>
	<20070925163040.12a3c2f8@the-village.bc.nu>
	<46F92AAB.1060903@davidnewall.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 01:05:07 +0930
David Newall <david@davidnewall.com> wrote:

> Alan Cox wrote:
> >> Marek's loading dynamic libraries, it seems clear that the prime purpose 
> >> of chroot is to aid security.  Being able to cd your way out is handy 
> >>     
> >
> > Does it - I can't find any evidence for that.
> 
> It seems self-evident to me.  What do you think is it prime purpose?

Debugging and testing. At least that is as I understand it much of where
it came from.

> > A root user can get out of a chroot a million different ways
> One of those ways shouldn't be that chroot lets you out.

A fence with 10000 open gates is not improved by turning it into a fence
with 9999 open gates. 
