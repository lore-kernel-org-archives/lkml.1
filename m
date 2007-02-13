Return-Path: <linux-kernel-owner+w=401wt.eu-S1751186AbXBMIWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186AbXBMIWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 03:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbXBMIWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 03:22:52 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:30268 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbXBMIWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 03:22:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=MWaMYBowVC3R42X6g3v/w322PNegXcLAOjlVgRsYVgevHF9746tAe8MCsxCD/Ca9INt7OTThX8Zk+eGoLhJnki10SfeF3MmrUMKGXKCLG3jrnLuhmPrYvS7U4nlYUqmoxGMuaggghzAolKKGGybkRPEjsiaFdcc4XCpeDYNGSRs=
Message-ID: <2375c9f90702130022y783f9fb1pd78f0f17deb38165@mail.gmail.com>
Date: Tue, 13 Feb 2007 16:22:50 +0800
From: "Cong WANG" <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH]Style fix for fs/select.c
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Style fix in fs/select.c.

Signed-off-by: WANG Cong  <xiyou.wangcong@gmail.com>
----
--- fs/select.c.orig	2007-02-13 12:42:37.000000000 +0800
+++ fs/select.c	2007-02-13 12:46:44.000000000 +0800
@@ -65,7 +65,7 @@ EXPORT_SYMBOL(poll_initwait);

 static void free_poll_entry(struct poll_table_entry *entry)
 {
-	remove_wait_queue(entry->wait_address,&entry->wait);
+	remove_wait_queue(entry->wait_address, &entry->wait);
 	fput(entry->filp);
 }

@@ -129,7 +129,7 @@ static void __pollwait(struct file *filp
 	entry->filp = filp;
 	entry->wait_address = wait_address;
 	init_waitqueue_entry(&entry->wait, current);
-	add_wait_queue(wait_address,&entry->wait);
+	add_wait_queue(wait_address, &entry->wait);
 }

 #define FDS_IN(fds, n)		(fds->in + n)
