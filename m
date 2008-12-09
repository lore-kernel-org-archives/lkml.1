Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbYLIRyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbYLIRyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 12:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755049AbYLIRyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 12:54:32 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:55314 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbYLIRyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 12:54:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=DdRlVV7ZSg618bfRtIgMpfL6K9mxvmIFBuWaaS/S9Ui6hTM1xGKzb779Es497xlkhY
         0H/2nzT8EmQOZtmskte0ru/ocBGdA6iEn3trcPRuNEONYZhsHpHBfkU2MYqGH4i01xax
         EgmQZz3X4tAVG84sV5/eBqdE52832TWvAWLk0=
Message-ID: <493EB0D5.3080606@gmail.com>
Date: Tue, 09 Dec 2008 18:54:29 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: dougthompson@xmission.com, bluesmoke-devel@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 8/33] drivers/edac: Make static
References: <493EA286.7080500@gmail.com>
In-Reply-To: <493EA286.7080500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse asked whether these could be static.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/edac/x38_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/x38_edac.c b/drivers/edac/x38_edac.c
index 2406c2c..c25175a 100644
--- a/drivers/edac/x38_edac.c
+++ b/drivers/edac/x38_edac.c
@@ -243,7 +243,7 @@ static void x38_check(struct mem_ctl_info *mci)
 }
 
 
-void __iomem *x38_map_mchbar(struct pci_dev *pdev)
+static void __iomem *x38_map_mchbar(struct pci_dev *pdev)
 {
 	union {
 		u64 mchbar;
