Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbYEMLna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbYEMLna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 07:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbYEMLnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 07:43:21 -0400
Received: from yugo.dsd.sztaki.hu ([195.111.2.114]:52987 "EHLO
	yugo.frugalware.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbYEMLnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 07:43:20 -0400
From: Miklos Vajna <vmiklos@frugalware.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/3] x86: janitor work in video-vga.c
Date: Tue, 13 May 2008 13:35:25 +0200
Message-Id: <8779a478ff43d6ed589279078d2abbab789a2dc9.1210678238.git.vmiklos@frugalware.org>
X-Mailer: git-send-email 1.5.5.1.211.g65ea3.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just moved an open brace to the previous line.

Signed-off-by: Miklos Vajna <vmiklos@frugalware.org>
---
 arch/x86/boot/video-vga.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/video-vga.c b/arch/x86/boot/video-vga.c
index 40ecb8d..b939cb4 100644
--- a/arch/x86/boot/video-vga.c
+++ b/arch/x86/boot/video-vga.c
@@ -259,8 +259,7 @@ static int vga_probe(void)
 	return mode_count[adapter];
 }
 
-__videocard video_vga =
-{
+__videocard video_vga = {
 	.card_name	= "VGA",
 	.probe		= vga_probe,
 	.set_mode	= vga_set_mode,
-- 
1.5.4.3

