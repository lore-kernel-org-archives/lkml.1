Return-Path: <linux-kernel-owner+w=401wt.eu-S1750757AbXBMP5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750757AbXBMP5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 10:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbXBMP5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 10:57:53 -0500
Received: from smtp.nokia.com ([131.228.20.173]:61305 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbXBMP5w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 10:57:52 -0500
Subject: Pull UBI tree
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Andreas Arnez <arnez@vnet.ibm.com>,
       Frank Haverkamp <haver@vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 13 Feb 2007 17:34:12 +0200
Message-Id: <1171380852.17314.55.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 13 Feb 2007 15:34:13.0402 (UTC) FILETIME=[69E19FA0:01C74F84]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

The UBI tree has been in -mm for a few releases now and we would like to
to see it in the mainline.

We have several groups using the code now and it has proved to be fairly
stable thus far. We've also got some feedback from people outside the
community.

In short, UBI is kind of LVM layer but for flash (MTD) devices. It makes
it possible to dynamically create, delete and re-size volumes. But the
analogy is not full. UBI also takes care of wear-leveling and bad
eraseblocks handling, so UBI completely hides 2 aspects of flash chips
which make them very difficult to work with:

1. wear of eraseblocks;
2. bad eraseblocks.

There is some documentation available at:
http://www.linux-mtd.infradead.org/doc/ubi.html
http://www.linux-mtd.infradead.org/faq/ubi.html

The sources are available via the GIT tree:
git://git.infradead.org/ubi-2.6.git

The tree is based on your current git tree and is ready to pull from.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

