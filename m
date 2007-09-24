Return-Path: <linux-kernel-owner+w=401wt.eu-S1759606AbXIXNSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606AbXIXNSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 09:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758658AbXIXNSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 09:18:31 -0400
Received: from sacred.ru ([62.205.161.221]:55403 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756192AbXIXNSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 09:18:30 -0400
Message-ID: <46F7B737.4020001@openvz.org>
Date: Mon, 24 Sep 2007 17:10:15 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc7-mm1
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org> <46F7B3B3.7010600@linux.vnet.ibm.com>
In-Reply-To: <46F7B3B3.7010600@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 24 Sep 2007 17:12:37 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please, try with this patch too:

diff --git a/fs/locks.c b/fs/locks.c
index c0fe71a..f599508 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1423,7 +1423,7 @@ int generic_setlease(struct file *filp, 
 	locks_copy_lock(new_fl, lease);
 	locks_insert_lock(before, new_fl);
 
-	*flp = fl;
+	*flp = new_fl;
 	return 0;
 
 out:

