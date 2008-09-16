Return-Path: <linux-kernel-owner+w=401wt.eu-S1752479AbYIPTwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbYIPTwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 15:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750880AbYIPTv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 15:51:56 -0400
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:60679 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbYIPTvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 15:51:55 -0400
Message-ID: <48D00E50.7080901@freemail.hu>
Date: Tue, 16 Sep 2008 21:51:44 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: LKML <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>
Subject: [PATCH] cdrom: update ioctl documentation
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail02d.mail.t-online.hu 32720; Body=3 Fuz1=3
	Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

Correct copy-paste problem: CDROMCLOSETRAY is about closing the tray,
not opening it.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- linux-2.6.27-rc6/Documentation/ioctl/cdrom.txt.orig	2008-07-13 23:51:29.000000000 +0200
+++ linux-2.6.27-rc6/Documentation/ioctl/cdrom.txt	2008-09-16 20:29:16.000000000 +0200
@@ -271,14 +271,14 @@ CDROMCLOSETRAY			pendant of CDROMEJECT

 	usage:

-	  ioctl(fd, CDROMEJECT, 0);
+	  ioctl(fd, CDROMCLOSETRAY, 0);

 	inputs:		none

 	outputs:	none

 	error returns:
-	  ENOSYS	cd drive not capable of ejecting
+	  ENOSYS	cd drive not capable of closing the tray
 	  EBUSY		other processes are accessing drive, or door is locked

 	notes:
