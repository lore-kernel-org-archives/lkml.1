Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbZADLod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbZADLod (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 06:44:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbZADLoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 06:44:24 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36596 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751383AbZADLoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 06:44:24 -0500
Date: Sun, 4 Jan 2009 11:44:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Adam Nielsen <a.nielsen@shikadi.net>,
       Christoph Hellwig <hch@infradead.org>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: XFS internal error xfs_da_do_buf(1) at line 2015 of file
 fs/xfs/xfs_da_btree.c
Message-ID: <20090104114425.241f6630@lxorguk.ukuu.org.uk>
In-Reply-To: <20090104092349.GA26194@infradead.org>
References: <49600DE6.2080108@shikadi.net>
	<20090104074659.GA16775@infradead.org>
	<49607B5B.3070707@shikadi.net>
	<20090104092349.GA26194@infradead.org>
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

> On Debian based systems you can add -W0 to /etc/default/hdparm and
> it gets executed before the root filesystem is remounted read-write,
> I'm not sure how other distributions handle it.

Generally they avoid setting -W0 because it ruins performance and can be
very bad for disk lifetime. The barriers code is there for a reason.

Of course certain distributions default to using LVM for all their file
systems which is completely and mindbogglingly bogus. That both messes up
barriers in some cases and takes a good 10-20% off performance when I've
benched it.

LVM is cool - if you need it, most people don't.

Alan
