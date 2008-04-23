Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbYDWJxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbYDWJxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 05:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbYDWJvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:51:16 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36849 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755045AbYDWJvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:51:15 -0400
Date: Wed, 23 Apr 2008 12:50:36 +0300
From: Adrian Bunk <bunk@kernel.org>
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] tpm_bios.c: make 2 structs static
Message-ID: <20080423095036.GN28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes two needlessly global structs static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 14 Apr 2008
- 31 Mar 2008

 drivers/char/tpm/tpm_bios.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

030a8d37553ae500a00cd0005c763863452b7cbc diff --git a/drivers/char/tpm/tpm_bios.c b/drivers/char/tpm/tpm_bios.c
index 60a2d26..68f052b 100644
--- a/drivers/char/tpm/tpm_bios.c
+++ b/drivers/char/tpm/tpm_bios.c
@@ -448,7 +448,7 @@ out_free:
 	goto out;
 }
 
-const struct file_operations tpm_ascii_bios_measurements_ops = {
+static const struct file_operations tpm_ascii_bios_measurements_ops = {
 	.open = tpm_ascii_bios_measurements_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -486,7 +486,7 @@ out_free:
 	goto out;
 }
 
-const struct file_operations tpm_binary_bios_measurements_ops = {
+static const struct file_operations tpm_binary_bios_measurements_ops = {
 	.open = tpm_binary_bios_measurements_open,
 	.read = seq_read,
 	.llseek = seq_lseek,


