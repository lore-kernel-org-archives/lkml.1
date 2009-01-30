Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbZA3KXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbZA3KXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 05:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756884AbZA3KWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 05:22:11 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34799 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755933AbZA3KWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 05:22:09 -0500
Date: Fri, 30 Jan 2009 10:21:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: david@lang.hm
Cc: Bill Davidsen <davidsen@tmr.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Switching from (deprecated) IDE driver -> SATA (PATA support)
Message-ID: <20090130102156.1219bb2b@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.DEB.1.10.0901291937290.24753@asgard.lang.hm>
References: <alpine.DEB.1.10.0901250553430.2441@p34.internal.lan>
	<200901252027.43376.bzolnier@gmail.com>
	<alpine.DEB.1.10.0901251612310.16676@p34.internal.lan>
	<200901252239.26268.bzolnier@gmail.com>
	<498240B7.6010500@tmr.com>
	<alpine.DEB.1.10.0901291937290.24753@asgard.lang.hm>
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

> what was the problem with these? I have somthing in this family in one of 
> my secondary boxes (I'd have to go check exactly which model)

343/363 don't work unless you use the alternate access via the BAR4
register range and leave BAR0-3 alone. That means you can't use the
standard IDE setup helper logic with them.

366 and later (which is almost certainly what you will have) replace this
with a different collection of errata which are handled by both sets of
drivers.

Alan
