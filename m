Return-Path: <linux-kernel-owner+w=401wt.eu-S1758175AbYFPNky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbYFPNky (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 09:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757340AbYFPNkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 09:40:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51509 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757299AbYFPNkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 09:40:40 -0400
From: Andre Haupt <andre@bitwigglers.org>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andre Haupt <andre@bitwigglers.org>
Subject: [PATCH] stallion: removed unused variable
Date: Mon, 16 Jun 2008 15:40:33 +0200
Message-Id: <1213623634-8120-2-git-send-email-andre@bitwigglers.org>
X-Mailer: git-send-email 1.5.5.GIT
X-Provags-ID: V01U2FsdGVkX19C4m8+QtbhTVgOWvs8s0mVLHxPt3Ln4VHdvQ/
 QnTqoHWh6BPBLVRCyFaMx3tJ1CDHnyP3XZ55ZFhV1rP80RMmja
 prHVRH9TdGWcUQmwIXp8gBIbHeBN9SGDi5tQXv0GEM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andre Haupt <andre@bitwigglers.org>
---
 drivers/char/stallion.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index d17be10..66370d5 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -1255,7 +1255,6 @@ static int stl_tiocmset(struct tty_struct *tty, struct file *file,
 static int stl_ioctl(struct tty_struct *tty, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct stlport	*portp;
-	unsigned int	ival;
 	int		rc;
 	void __user *argp = (void __user *)arg;
 
-- 
1.5.5.GIT

