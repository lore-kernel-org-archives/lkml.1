Return-Path: <linux-kernel-owner+w=401wt.eu-S1761362AbYDTS0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761362AbYDTS0U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 14:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbYDTSYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 14:24:39 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:45911 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838AbYDTSYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 14:24:36 -0400
Subject: [PATCH 6/9] fat: Remove fat_clusters_flush()
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Mon, 21 Apr 2008 03:13:27 +0900
Message-ID: <dedb5bd83e8480b87c765695.ps@mail.parknet.co.jp>
References: <60d0156a3e8480b87c215695.ps@mail.parknet.co.jp>
	<5cb1b5773e8480b87c425695.ps@mail.parknet.co.jp>
	<954304cc3e8480b87c535695.ps@mail.parknet.co.jp>
	<f6f833103e8480b87c645695.ps@mail.parknet.co.jp>
	<89121f633e8480b87c755695.ps@mail.parknet.co.jp>
In-Reply-To: <89121f633e8480b87c755695.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This removes unneeded fat_clusters_flush().

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/fatent.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/fat/fatent.c~fat-remove-fat_clusters_flush fs/fat/fatent.c
--- linux-2.6/fs/fat/fatent.c~fat-remove-fat_clusters_flush	2008-04-19 11:55:07.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/fatent.c	2008-04-19 11:55:07.000000000 +0900
@@ -585,8 +585,6 @@ error:
 		brelse(bhs[i]);
 	unlock_fat(sbi);
 
-	fat_clusters_flush(sb);
-
 	return err;
 }
 
_
