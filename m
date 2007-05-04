Return-Path: <linux-kernel-owner+w=401wt.eu-S1754243AbXEDMfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbXEDMfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 08:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754924AbXEDMfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 08:35:50 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:56242 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243AbXEDMft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 08:35:49 -0400
Date: Fri, 4 May 2007 14:34:57 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Rewrite the MAJOR() macro as a call to imajor().
In-Reply-To: <Pine.LNX.4.64.0705040809510.24097@localhost.localdomain>
Message-ID: <Pine.LNX.4.61.0705041433530.18504@yvahk01.tjqt.qr>
References: <Pine.LNX.4.64.0704280621350.516@localhost.localdomain>
 <20070503231814.e12ad2d7.akpm@linux-foundation.org>
 <Pine.LNX.4.61.0705041008180.18504@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0705040410390.20834@localhost.localdomain>
 <Pine.LNX.4.61.0705041340310.18504@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0705040809510.24097@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 4 2007 08:21, Robert P. J. Day wrote:
>arch/sh/boards/landisk/landisk_pwb.c:   minor = MINOR(inode->i_rdev);
>arch/sh/boards/landisk/landisk_pwb.c:   minor = MINOR(inode->i_rdev);
>drivers/block/loop.c:   return i && S_ISBLK(i->i_mode) && MAJOR(i->i_rdev) == LOOP_MAJOR;
>drivers/media/video/ivtv/ivtv-fileops.c:        int minor = MINOR(inode->i_rdev);
>include/linux/fs.h:     return MINOR(inode->i_rdev);
>include/linux/fs.h:     return MAJOR(inode->i_rdev);
>sound/oss/au1550_ac97.c:        int             minor = MINOR(inode->i_rdev);
>
>who's in charge of video/ivtv (hints?)

>From maintainers:

VIDEO FOR LINUX
P:      Mauro Carvalho Chehab
M:      mchehab@infradead.org
M:      v4l-dvb-maintainer@linuxtv.org
L:      video4linux-list@redhat.com
W:      http://linuxtv.org
T:      git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
S:      Maintained



Jan
-- 
