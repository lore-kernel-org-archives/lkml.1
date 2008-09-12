Return-Path: <linux-kernel-owner+w=401wt.eu-S1758782AbYILWMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782AbYILWMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 18:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbYILWM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 18:12:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:60188 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758698AbYILWMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 18:12:25 -0400
X-Mailer: QUALCOMM Windows Eudora Version 7.1.0.9
Date: Sat, 13 Sep 2008 00:11:09 +0200
To: linux-kernel@vger.kernel.org
From: Harun Scheutzow <harun04@scheutzow.de>
Subject: Re: vfat file system extreme fragmentation on multiprocessor
In-Reply-To: <E1Ke8YZ-0001Ss-QE@be1.7eggert.dyndns.org>
References: <baZfg-1yC-3@gated-at.bofh.it>
 <baZS2-2rX-15@gated-at.bofh.it>
 <E1Ke8YZ-0001Ss-QE@be1.7eggert.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <0ML2xA-1KeGsB0BuB-00032S@mrelayeu.kundenserver.de>
X-Provags-ID: V01U2FsdGVkX194jm9Ck+1rPtw2TBWMtd23VqwC8C8kU3Ta4HB
 9utkZiuqf5i1RzWmtMHbNvFORZc2uXGLyEeG8ZVOY9QlOL78xC
 jql3VzpxnYgpU+RtVLwWA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the records:

Both Windows Vista and XP SP3 produce very little or no fragmentation on same FAT partition and same workload (2 tasks writing in 50 MByte pieces, up to some hundred MByte file size). But XP SP3 has a stupid behavior, too, allocating new space always behind previous allocations, even if old files have already been really deleted (not in trash), at least for one session (not tried what happens after reboot). This can result in multi-GByte holes of free space.

Harun Scheutzow

