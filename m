Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653AbZA3KLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbZA3KLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 05:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZA3KLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 05:11:33 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36431 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750992AbZA3KLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 05:11:31 -0500
Date: Fri, 30 Jan 2009 10:11:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Switching from (deprecated) IDE driver -> SATA (PATA support)
Message-ID: <20090130101134.1bb4d3b2@lxorguk.ukuu.org.uk>
In-Reply-To: <498240B7.6010500@tmr.com>
References: <alpine.DEB.1.10.0901250553430.2441@p34.internal.lan>
	<200901252027.43376.bzolnier@gmail.com>
	<alpine.DEB.1.10.0901251612310.16676@p34.internal.lan>
	<200901252239.26268.bzolnier@gmail.com>
	<498240B7.6010500@tmr.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > However if you need we can bring support for HPT34x hardware back. :)
> 
> I don't think "bring it back" is enough, it had some major issues as I recall. I 
> actually have a pile of these, but not running any recent kernel.

And me - I've spent some time trying to dig deeper into the DMA on the
HPT343 but there isn't any useful documentation and Andre didn't have any
immediate insights (other than a slightly less than printable review of
his opinion of the device)

In PIO its pretty solid, but for the original 343 at least DMA is still a
bit of a mystery that might not be solved without a bus analyser - for
one it completes DMA transfers but they don't seem to arrive in the
location specified in the PRD, even if you try obvious errata type things
like 64K alignment.

Unfortunately if the errata is something gross like flipping bits in PRD
addresses we aren't going to be able to figure it out.

Alan
