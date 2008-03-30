Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbYC3XNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbYC3XNg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 19:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756594AbYC3XMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 19:12:54 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:58708 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756526AbYC3XMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 19:12:53 -0400
Date: Mon, 31 Mar 2008 02:12:41 +0300
From: Adrian Bunk <bunk@kernel.org>
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] tpm_bios.c: make 2 structs static
Message-ID: <20080330231241.GC28445@cs181133002.pp.htv.fi>
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

