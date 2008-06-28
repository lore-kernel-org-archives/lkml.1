Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbYF1RYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbYF1RYv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 13:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbYF1RYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 13:24:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:24789 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbYF1RYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 13:24:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type:sender;
        b=JkLU7iFmhuA6TgmBybE97ytIyWrU68dCXdaCkXfoDJctQdUnhLdg6F9OCnoLZnrX+h
         M7ZKrNwKVA/ok31QosmjTxLc9wMBpXHy5cp+LGAEOlWycnqWRNfQc+PtATZrEGg8clti
         22wi0WqeEQMB9Alz71oFhikU+e0UpNGtqvyIc=
Date: Sat, 28 Jun 2008 19:24:21 +0200 (CEST)
From: Marcin Obara <marcin_obara@users.sourceforge.net>
X-X-Sender: marcin_obara@ip-195-3-221-75.vnet.pl
To: tpmdd-devel@lists.sourceforge.net, Marcel Selhorst <tpm@selhorst.net>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tpm: add Intel TPM TIS device HID
Message-ID: <alpine.DEB.1.00.0806281913410.7076@ip-195-3-221-75.vnet.pl>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Intel TPM TIS device HID :  ICO0102

Signed-off-by: Marcin Obara <marcin_obara@users.sourceforge.net>

--- linux_tpm/drivers/char/tpm/tpm_tis.c	2008-06-05 20:51:13.000000000 +0200
+++ linux_intel/drivers/char/tpm/tpm_tis.c	2008-06-25 06:31:39.000000000 +0200
@@ -623,6 +623,7 @@ static struct pnp_device_id tpm_pnp_tbl[
 	{"IFX0102", 0},		/* Infineon */
 	{"BCM0101", 0},		/* Broadcom */
 	{"NSC1200", 0},		/* National */
+	{"ICO0102", 0},		/* Intel */
 	/* Add new here */
 	{"", 0},		/* User Specified */
 	{"", 0}			/* Terminator */
