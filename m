Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab0BHA0M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 19:26:12 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:58358 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab0BHA0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 19:26:08 -0500
From: Andreas Schwab <schwab@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] compat_ioctl: add compat handler for TIOCGSID ioctl
X-Yow: Someone is DROOLING on my collar!!
Date: Mon, 08 Feb 2010 01:26:03 +0100
Message-ID: <m21vgwa7z8.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is used by tcgetsid(3).

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
---
 fs/compat_ioctl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index c5c45de..a2f21bc 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -936,6 +936,7 @@ COMPATIBLE_IOCTL(TCSETSF)
 COMPATIBLE_IOCTL(TIOCLINUX)
 COMPATIBLE_IOCTL(TIOCSBRK)
 COMPATIBLE_IOCTL(TIOCCBRK)
+COMPATIBLE_IOCTL(TIOCGSID)
 COMPATIBLE_IOCTL(TIOCGICOUNT)
 /* Little t */
 COMPATIBLE_IOCTL(TIOCGETD)
-- 
1.6.6.1


-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
