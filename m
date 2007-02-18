Return-Path: <linux-kernel-owner+w=401wt.eu-S1751857AbXBRS7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbXBRS7L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 13:59:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbXBRS7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 13:59:11 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:37298 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbXBRS7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 13:59:09 -0500
X-Originating-Ip: 74.109.98.130
Date: Sun, 18 Feb 2007 13:53:13 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Roman Zippel <zippel@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: Add the code maturity levels DEPRECATED and
 OBSOLETE.
In-Reply-To: <200702181935.07454.bzolnier@gmail.com>
Message-ID: <Pine.LNX.4.64.0702181348510.4861@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0702181203360.5131@CPE00045a9c397f-CM001225dbafb6>
 <200702181935.07454.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Feb 2007, Bartlomiej Zolnierkiewicz wrote:

> Hi,
>
> Would it be possible to get this patch merged
> (or at least DEPRECATED part of it)?
>
> I think that the patch is useful and that the distinction between
> DEPRECATED and OBSOLETE options is quite clear:
>
> * DEPRECATED == new better code is available, old code scheduled for removal
>
> * OBSOLETE == no replacement yet but the code is broken by design
>   and unreliable, not scheduled for removal yet (BTW Robert, I think
>   CONFIG_OBSOLETE should also be "default y", at least initially)

for the most part, that doesn't matter to me one way or the other but,
personally, i'd make obsolete kernel features default to "n".  after
all, if someone has gone to the trouble to actually make that config
option *depend* on OBSOLETE, that's a powerful argument that you
should have to work a bit to get it back again. :-)

but i'm good either way.

rday

p.s.  for people who missed it the first time, a record of the initial
discussion is here:

  http://kerneltrap.org/node/7593
