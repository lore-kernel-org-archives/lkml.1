Return-Path: <linux-kernel-owner+w=401wt.eu-S1764519AbZDHLbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764519AbZDHLbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763508AbZDHLXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:23:33 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:44127 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763396AbZDHLXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:23:31 -0400
X-Sasl-enc: 2hTHfSHu2HSHegjwLKFN4+Se72p+Y1yxoSMBcLQGGF/V 1239189807
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 18/56] isdn: Remove void casts
Date: Wed,  8 Apr 2009 12:21:50 +0100
Message-Id: <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---
 drivers/isdn/hardware/eicon/capifunc.c  |    2 +-
 drivers/isdn/hardware/eicon/diddfunc.c  |    2 +-
 drivers/isdn/hardware/eicon/divasfunc.c |    2 +-
 drivers/isdn/hardware/eicon/divasi.c    |   27 ++++++++-------------------
 drivers/isdn/hardware/eicon/idifunc.c   |    2 +-
 drivers/isdn/hardware/eicon/mntfunc.c   |    2 +-
 drivers/isdn/hardware/eicon/s_4bri.c    |    2 +-
 drivers/isdn/hardware/eicon/um_idi.c    |    7 ++-----
 8 files changed, 16 insertions(+), 30 deletions(-)

diff --git a/drivers/isdn/hardware/eicon/capifunc.c b/drivers/isdn/hardware/eicon/capifunc.c
index 4d425c6..7027547 100644
--- a/drivers/isdn/hardware/eicon/capifunc.c
+++ b/drivers/isdn/hardware/eicon/capifunc.c
@@ -1072,7 +1072,7 @@ static int divacapi_connect_didd(void)
 			req.didd_notify.e.Req = 0;
 			req.didd_notify.e.Rc =
 			    IDI_SYNC_REQ_DIDD_REGISTER_ADAPTER_NOTIFY;
-			req.didd_notify.info.callback = (void *)didd_callback;
+			req.didd_notify.info.callback = didd_callback;
 			req.didd_notify.info.context = NULL;
 			DAdapter.request((ENTITY *) & req);
 			if (req.didd_notify.e.Rc != 0xff) {
diff --git a/drivers/isdn/hardware/eicon/diddfunc.c b/drivers/isdn/hardware/eicon/diddfunc.c
index 3029234..d97bfba 100644
--- a/drivers/isdn/hardware/eicon/diddfunc.c
+++ b/drivers/isdn/hardware/eicon/diddfunc.c
@@ -63,7 +63,7 @@ static int DIVA_INIT_FUNCTION connect_didd(void)
 			req.didd_notify.e.Req = 0;
 			req.didd_notify.e.Rc =
 			    IDI_SYNC_REQ_DIDD_REGISTER_ADAPTER_NOTIFY;
-			req.didd_notify.info.callback = (void *)didd_callback;
+			req.didd_notify.info.callback = didd_callback;
 			req.didd_notify.info.context = NULL;
 			_DAdapter.request((ENTITY *) & req);
 			if (req.didd_notify.e.Rc != 0xff)
diff --git a/drivers/isdn/hardware/eicon/divasfunc.c b/drivers/isdn/hardware/eicon/divasfunc.c
index d36a4c0..2616a22 100644
--- a/drivers/isdn/hardware/eicon/divasfunc.c
+++ b/drivers/isdn/hardware/eicon/divasfunc.c
@@ -170,7 +170,7 @@ static int DIVA_INIT_FUNCTION connect_didd(void)
 			req.didd_notify.e.Req = 0;
 			req.didd_notify.e.Rc =
 			    IDI_SYNC_REQ_DIDD_REGISTER_ADAPTER_NOTIFY;
-			req.didd_notify.info.callback = (void *)didd_callback;
+			req.didd_notify.info.callback = didd_callback;
 			req.didd_notify.info.context = NULL;
 			DAdapter.request((ENTITY *) & req);
 			if (req.didd_notify.e.Rc != 0xff) {
diff --git a/drivers/isdn/hardware/eicon/divasi.c b/drivers/isdn/hardware/eicon/divasi.c
index 69e71eb..9021581 100644
--- a/drivers/isdn/hardware/eicon/divasi.c
+++ b/drivers/isdn/hardware/eicon/divasi.c
@@ -238,8 +238,7 @@ um_idi_read(struct file *file, char __user *buf, size_t count, loff_t * offset)
 	}
 
 	if (!
-	    (p_os =
-	     (diva_um_idi_os_context_t *) diva_um_id_get_os_context(file->
+	    (p_os = diva_um_id_get_os_context(file->
 								    private_data)))
 	{
 		return (-ENODEV);
@@ -296,7 +295,7 @@ static int um_idi_open_adapter(struct file *file, int adapter_nr)
 	if (!(file->private_data = e)) {
 		return (0);
 	}
-	p_os = (diva_um_idi_os_context_t *) diva_um_id_get_os_context(e);
+	p_os = diva_um_id_get_os_context(e);
 	init_waitqueue_head(&p_os->read_wait);
 	init_waitqueue_head(&p_os->close_wait);
 	init_timer(&p_os->diva_timer_id);
@@ -329,8 +328,7 @@ um_idi_write(struct file *file, const char __user *buf, size_t count,
 			return (-ENODEV);
 	}
 
-	if (!(p_os =
-	     (diva_um_idi_os_context_t *) diva_um_id_get_os_context(file->
+	if (!(p_os = diva_um_id_get_os_context(file->
 								    private_data)))
 	{
 		return (-ENODEV);
@@ -374,9 +372,7 @@ static unsigned int um_idi_poll(struct file *file, poll_table * wait)
 		return (POLLERR);
 	}
 
-	if ((!(p_os =
-	       (diva_um_idi_os_context_t *)
-	       diva_um_id_get_os_context(file->private_data)))
+	if ((!(p_os = diva_um_id_get_os_context(file->private_data)))
 	    || p_os->aborted) {
 		return (POLLERR);
 	}
@@ -416,8 +412,7 @@ static int um_idi_release(struct inode *inode, struct file *file)
 		goto out;
 	}
 
-	if (!(p_os =
-		(diva_um_idi_os_context_t *) diva_um_id_get_os_context(file->private_data))) {
+	if (!(p_os = diva_um_id_get_os_context(file->private_data))) {
 		ret = -ENODEV;
 		goto out;
 	}
@@ -484,9 +479,7 @@ static int remove_entity(void *entity)
 		return (0);
 	}
 
-	if (!(p_os =
-	     (diva_um_idi_os_context_t *)
-	     diva_um_id_get_os_context(entity))) {
+	if (!(p_os = diva_um_id_get_os_context(entity))) {
 		DBG_FTL(("Zero entity os context on remove"))
 		return (0);
 	}
@@ -557,9 +550,7 @@ void diva_um_idi_start_wdog(void *entity)
 	diva_um_idi_os_context_t *p_os;
 
 	if (entity &&
-	    ((p_os =
-	      (diva_um_idi_os_context_t *)
-	      diva_um_id_get_os_context(entity)))) {
+	    ((p_os = diva_um_id_get_os_context(entity)))) {
 		mod_timer(&p_os->diva_timer_id, jiffies + 10 * HZ);
 	}
 }
@@ -569,9 +560,7 @@ void diva_um_idi_stop_wdog(void *entity)
 	diva_um_idi_os_context_t *p_os;
 
 	if (entity &&
-	    ((p_os =
-	      (diva_um_idi_os_context_t *)
-	      diva_um_id_get_os_context(entity)))) {
+	    ((p_os = diva_um_id_get_os_context(entity)))) {
 		del_timer(&p_os->diva_timer_id);
 	}
 }
diff --git a/drivers/isdn/hardware/eicon/idifunc.c b/drivers/isdn/hardware/eicon/idifunc.c
index db87d51..5399cc1 100644
--- a/drivers/isdn/hardware/eicon/idifunc.c
+++ b/drivers/isdn/hardware/eicon/idifunc.c
@@ -197,7 +197,7 @@ static int DIVA_INIT_FUNCTION connect_didd(void)
 			req.didd_notify.e.Req = 0;
 			req.didd_notify.e.Rc =
 			    IDI_SYNC_REQ_DIDD_REGISTER_ADAPTER_NOTIFY;
-			req.didd_notify.info.callback = (void *)didd_callback;
+			req.didd_notify.info.callback = didd_callback;
 			req.didd_notify.info.context = NULL;
 			DAdapter.request((ENTITY *) & req);
 			if (req.didd_notify.e.Rc != 0xff) {
diff --git a/drivers/isdn/hardware/eicon/mntfunc.c b/drivers/isdn/hardware/eicon/mntfunc.c
index a564b75..2251662 100644
--- a/drivers/isdn/hardware/eicon/mntfunc.c
+++ b/drivers/isdn/hardware/eicon/mntfunc.c
@@ -88,7 +88,7 @@ static int DIVA_INIT_FUNCTION connect_didd(void)
 			req.didd_notify.e.Req = 0;
 			req.didd_notify.e.Rc =
 			    IDI_SYNC_REQ_DIDD_REGISTER_ADAPTER_NOTIFY;
-			req.didd_notify.info.callback = (void *)didd_callback;
+			req.didd_notify.info.callback = didd_callback;
 			req.didd_notify.info.context = NULL;
 			DAdapter.request((ENTITY *) & req);
 			if (req.didd_notify.e.Rc != 0xff)
diff --git a/drivers/isdn/hardware/eicon/s_4bri.c b/drivers/isdn/hardware/eicon/s_4bri.c
index 25c5d7f..28e8410 100644
--- a/drivers/isdn/hardware/eicon/s_4bri.c
+++ b/drivers/isdn/hardware/eicon/s_4bri.c
@@ -189,7 +189,7 @@ static byte * qBri_check_FPGAsrc (PISDN_ADAPTER IoAdapter, char *FileName,
 	char  *fpgaFile, *fpgaType, *fpgaDate, *fpgaTime ;
 	dword  fpgaFlen,  fpgaTlen,  fpgaDlen, cnt, year, i ;
 
-	if (!(File = (byte *)xdiLoadFile (FileName, Length, 0))) {
+	if (!(File = xdiLoadFile (FileName, Length, 0))) {
 		return (NULL) ;
 	}
 /*
diff --git a/drivers/isdn/hardware/eicon/um_idi.c b/drivers/isdn/hardware/eicon/um_idi.c
index 6563db9..55eb212 100644
--- a/drivers/isdn/hardware/eicon/um_idi.c
+++ b/drivers/isdn/hardware/eicon/um_idi.c
@@ -679,9 +679,7 @@ static int process_idi_ind(divas_um_idi_entity_t * e, byte ind)
 	int do_wakeup = 0;
 
 	if (e->e.complete != 0x02) {
-		diva_um_idi_ind_hdr_t *pind =
-		    (diva_um_idi_ind_hdr_t *)
-		    diva_data_q_get_segment4write(&e->data);
+		diva_um_idi_ind_hdr_t *pind = diva_data_q_get_segment4write(&e->data);
 		if (pind) {
 			e->e.RNum = 1;
 			e->e.R->P = (byte *) & pind[1];
@@ -734,8 +732,7 @@ static int write_return_code(divas_um_idi_entity_t * e, byte rc)
 {
 	diva_um_idi_ind_hdr_t *prc;
 
-	if (!(prc =
-	     (diva_um_idi_ind_hdr_t *) diva_data_q_get_segment4write(&e->rc)))
+	if (!(prc = diva_data_q_get_segment4write(&e->rc)))
 	{
 		DBG_ERR(("A: A(%d) E(%08x) rc(%02x) lost",
 			 e->adapter->adapter_nr, e, rc));
-- 
1.5.4.3

