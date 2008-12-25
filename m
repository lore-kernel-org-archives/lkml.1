Return-Path: <linux-kernel-owner+w=401wt.eu-S1752110AbYLYIHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbYLYIHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 03:07:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbYLYIGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 03:06:51 -0500
Received: from mail.ukfsn.org ([77.75.108.10]:33275 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbYLYIGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 03:06:50 -0500
Date: Thu, 25 Dec 2008 08:06:47 +0000
From: Nick Warne <nick@ukfsn.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Subject: [PATCH] EXT4: super.c - remove extraneous newline
Message-ID: <20081225080647.6890d867@sauron.linicks.net>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I just realised I forgot to finish typing the correct subject
line in my earlier mail :-)  Please ignore earlier mail with the same
patch.

Applies to stable 2.6.28.

Remove extraneous newline that creates empty print line
in boot logs.

Signed-off-by: Nick Warne <nick@ukfsn.org>

--- linux-2.6.28/fs/ext4/super.cORIG	2008-12-25
01:35:49.156527726 +0000 +++ linux-2.6.28/fs/ext4/super.c
2008-12-25 01:36:50.914527855 +0000 @@ -1973,7 +1973,7 @@
 	else
 		ext4_warning(sb, __func__,
 			"extents feature not enabled on this
filesystem, "
-			"use tune2fs.\n");
+			"use tune2fs.");
 
 	/*
 	 * enable delayed allocation by default


-- 
Free Software Foundation Associate Member 5508
http://linicks.net/
