Return-Path: <linux-kernel-owner+w=401wt.eu-S1755006AbYJEKRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbYJEKRk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 06:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbYJEKRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 06:17:33 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:60617 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbYJEKRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 06:17:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:x-pgp-key:user-agent:sender;
        b=SiUxdm9PxBdltsdL9fWPoHKgZP1Jn3qF1qKKt9ccvZm6iZUvEO1Ori1V5mtirWZoHZ
         d88TNI57TNzpY2DqKldegVdG74WIUItC4uTnnSgHQqG59qwRHPFzLjsZFzvcQ6fS9f4W
         v7qnRfwqkrcRobvJAqizoO3GXDR9+SLjf5Euk=
Date: Sun, 5 Oct 2008 12:16:04 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH] x86: replace a magic number with a named constant in the
	VESA boot code
Message-ID: <20081005101604.GA1995@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a magic number with a named constant in the VESA boot code.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
diff --git a/arch/x86/boot/video-vesa.c b/arch/x86/boot/video-vesa.c
index 401ad99..1e6fe02 100644
--- a/arch/x86/boot/video-vesa.c
+++ b/arch/x86/boot/video-vesa.c
@@ -224,7 +224,7 @@ static void vesa_store_pm_info(void)
 static void vesa_store_mode_params_graphics(void)
 {
 	/* Tell the kernel we're in VESA graphics mode */
-	boot_params.screen_info.orig_video_isVGA = 0x23;
+	boot_params.screen_info.orig_video_isVGA = VIDEO_TYPE_VLFB;
 
 	/* Mode parameters */
 	boot_params.screen_info.vesa_attributes = vminfo.mode_attr;

