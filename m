Return-Path: <linux-kernel-owner+w=401wt.eu-S932086AbYEESlC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbYEESlC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:41:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761551AbYEESaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:30:08 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:33113 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760092AbYEESaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:30:06 -0400
Date: Mon, 5 May 2008 21:28:57 +0300
From: Adrian Bunk <bunk@kernel.org>
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] tpm_bios.c: make 2 structs static
Message-ID: <20080505182857.GT17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes two needlessly global structs static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Marcel Selhorst <tpm@selhorst.net>

---

This patch has been sent on:
- 23 Apr 2008
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



