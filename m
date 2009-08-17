Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbZHQPgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbZHQPgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 11:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754993AbZHQPgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 11:36:00 -0400
Received: from kroah.org ([198.145.64.141]:35646 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754862AbZHQPf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 11:35:59 -0400
Date: Mon, 17 Aug 2009 08:34:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.30
Message-ID: <20090817153413.GB29515@kroah.com>
References: <20090817153358.GA29515@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090817153358.GA29515@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 0eef388..fa0d21e 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 27
-EXTRAVERSION = .30
+EXTRAVERSION = .31
 NAME = Trembling Tortoise
 
 # *DOCUMENTATION*
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 994ca87..61cb48f 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1910,7 +1910,6 @@ COMPATIBLE_IOCTL(FIONCLEX)
 COMPATIBLE_IOCTL(FIOASYNC)
 COMPATIBLE_IOCTL(FIONBIO)
 COMPATIBLE_IOCTL(FIONREAD)  /* This is also TIOCINQ */
-COMPATIBLE_IOCTL(FS_IOC_FIEMAP)
 /* 0x00 */
 COMPATIBLE_IOCTL(FIBMAP)
 COMPATIBLE_IOCTL(FIGETBSZ)
