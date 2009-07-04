Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbZGDDJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbZGDDJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 23:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbZGDDJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 23:09:44 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:41396 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbZGDDJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 23:09:43 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: tridge@samba.org
Cc: Jan Engelhardt <jengelh@medozas.de>, Theodore Tso <tytso@mit.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<200907012019.53932.rusty@rustcorp.com.au>
	<20090701122558.3a7c80d3@lxorguk.ukuu.org.uk>
	<20090701140503.GA21185@mit.edu>
	<alpine.LSU.2.00.0907030056210.17183@fbirervta.pbzchgretzou.qr>
	<alpine.LSU.2.00.0907030134291.17183@fbirervta.pbzchgretzou.qr>
	<19021.19842.663727.146474@samba.org>
	<87hbxu60qm.fsf@devron.myhome.or.jp>
	<19021.23231.213863.726785@samba.org>
	<alpine.LSU.2.00.0907030347210.24650@fbirervta.pbzchgretzou.qr>
	<19021.26102.80885.330380@samba.org>
	<alpine.LSU.2.00.0907030403330.26905@fbirervta.pbzchgretzou.qr>
	<19021.31291.642416.956966@samba.org>
	<alpine.LSU.2.00.0907031121250.16093@fbirervta.pbzchgretzou.qr>
	<19021.63615.450348.192109@samba.org>
Date: Sat, 04 Jul 2009 12:09:37 +0900
In-Reply-To: <19021.63615.450348.192109@samba.org> (tridge@samba.org's message
	of "Fri, 3 Jul 2009 22:24:31 +1000")
Message-ID: <87ljn5p2j2.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tridge@samba.org writes:

> Hirofumi-san, can you have a look at this too and see if it is how you
> want to handle it? I built the patch against your fatfs-2.6 tree.

Looks good to me. I've applied the patch + Cc:. 

>>From 244a8ebe72288a261e68b5aea04a86793a2f11f4 Mon Sep 17 00:00:00 2001
> From: Andrew Tridgell <tridge@samba.org>
> Date: Fri, 3 Jul 2009 22:15:02 +1000
> Subject: [PATCH] Force case handling when dualnames are disabled for greater compatibility

[PATCH] fat: Force case handling...

Please add "fat: " prefix at next time.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
