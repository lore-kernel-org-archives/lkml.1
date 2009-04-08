Return-Path: <linux-kernel-owner+w=401wt.eu-S1762977AbZDHLiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762977AbZDHLiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764677AbZDHL1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:27:43 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:47447 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932095AbZDHL1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:27:39 -0400
X-Sasl-enc: fJWbn6MEkGcbTYq82qoSz6jjx6kqY/D6i68weNf9DFye 1239190058
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 37/56] oss: Remove void casts
Date: Wed,  8 Apr 2009 12:22:09 +0100
Message-Id: <1239189748-11703-38-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239189748-11703-37-git-send-email-jwjstone@fastmail.fm>
References: <>
 <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-10-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-22-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-23-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-24-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-25-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-26-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-27-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-28-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-29-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-30-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-31-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-32-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-33-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-34-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-35-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-36-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-37-git-send-email-jwjstone@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---
 sound/oss/msnd.c      |    2 +-
 sound/oss/pss.c       |    6 +++---
 sound/oss/sequencer.c |    4 ++--
 sound/oss/sscape.c    |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/sound/oss/msnd.c b/sound/oss/msnd.c
index e4282d9..21eb6dc 100644
--- a/sound/oss/msnd.c
+++ b/sound/oss/msnd.c
@@ -100,7 +100,7 @@ void msnd_fifo_free(msnd_fifo *f)
 int msnd_fifo_alloc(msnd_fifo *f, size_t n)
 {
 	msnd_fifo_free(f);
-	f->data = (char *)vmalloc(n);
+	f->data = vmalloc(n);
 	f->n = n;
 	f->tail = 0;
 	f->head = 0;
diff --git a/sound/oss/pss.c b/sound/oss/pss.c
index 83f5ee2..82f4d5a 100644
--- a/sound/oss/pss.c
+++ b/sound/oss/pss.c
@@ -859,7 +859,7 @@ static int pss_coproc_ioctl(void *dev_info, unsigned int cmd, void __user *arg,
 			return 0;
 
 		case SNDCTL_COPR_LOAD:
-			buf = (copr_buffer *) vmalloc(sizeof(copr_buffer));
+			buf = vmalloc(sizeof(copr_buffer));
 			if (buf == NULL)
 				return -ENOSPC;
 			if (copy_from_user(buf, arg, sizeof(copr_buffer))) {
@@ -871,7 +871,7 @@ static int pss_coproc_ioctl(void *dev_info, unsigned int cmd, void __user *arg,
 			return err;
 		
 		case SNDCTL_COPR_SENDMSG:
-			mbuf = (copr_msg *)vmalloc(sizeof(copr_msg));
+			mbuf = vmalloc(sizeof(copr_msg));
 			if (mbuf == NULL)
 				return -ENOSPC;
 			if (copy_from_user(mbuf, arg, sizeof(copr_msg))) {
@@ -895,7 +895,7 @@ static int pss_coproc_ioctl(void *dev_info, unsigned int cmd, void __user *arg,
 
 		case SNDCTL_COPR_RCVMSG:
 			err = 0;
-			mbuf = (copr_msg *)vmalloc(sizeof(copr_msg));
+			mbuf = vmalloc(sizeof(copr_msg));
 			if (mbuf == NULL)
 				return -ENOSPC;
 			data = (unsigned short *)mbuf->data;
diff --git a/sound/oss/sequencer.c b/sound/oss/sequencer.c
index c798746..31c01ba 100644
--- a/sound/oss/sequencer.c
+++ b/sound/oss/sequencer.c
@@ -1648,13 +1648,13 @@ void sequencer_init(void)
 {
 	if (sequencer_ok)
 		return;
-	queue = (unsigned char *)vmalloc(SEQ_MAX_QUEUE * EV_SZ);
+	queue = vmalloc(SEQ_MAX_QUEUE * EV_SZ);
 	if (queue == NULL)
 	{
 		printk(KERN_ERR "sequencer: Can't allocate memory for sequencer output queue\n");
 		return;
 	}
-	iqueue = (unsigned char *)vmalloc(SEQ_MAX_QUEUE * IEV_SZ);
+	iqueue = vmalloc(SEQ_MAX_QUEUE * IEV_SZ);
 	if (iqueue == NULL)
 	{
 		printk(KERN_ERR "sequencer: Can't allocate memory for sequencer input queue\n");
diff --git a/sound/oss/sscape.c b/sound/oss/sscape.c
index 30c36d1..9d6b9b0 100644
--- a/sound/oss/sscape.c
+++ b/sound/oss/sscape.c
@@ -573,7 +573,7 @@ static int sscape_coproc_ioctl(void *dev_info, unsigned int cmd, void __user *ar
 			return 0;
 
 		case SNDCTL_COPR_LOAD:
-			buf = (copr_buffer *) vmalloc(sizeof(copr_buffer));
+			buf = vmalloc(sizeof(copr_buffer));
 			if (buf == NULL)
 				return -ENOSPC;
 			if (copy_from_user(buf, arg, sizeof(copr_buffer))) 
-- 
1.5.4.3

