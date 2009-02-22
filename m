Return-Path: <linux-kernel-owner+w=401wt.eu-S1756397AbZBVAJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbZBVAJk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 19:09:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbZBVAJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 19:09:32 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:41572 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712AbZBVAJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 19:09:31 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 07/16] panasonic-laptop: fix sparse warning: Using plain
	integer as NULL pointer
To: trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 22 Feb 2009 01:02:35 +0100
Message-ID: <20090222000228.17557.1852.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
References: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning:
  drivers/platform/x86/panasonic-laptop.c:273:70: warning: Using plain integer as NULL pointer

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/platform/x86/panasonic-laptop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index c47a44d..e178cde 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -270,7 +270,7 @@ static int acpi_pcc_retrieve_biosdata(struct pcc_acpi *pcc, u32 *sinf)
 	union acpi_object *hkey = NULL;
 	int i;
 
-	status = acpi_evaluate_object(pcc->handle, METHOD_HKEY_SINF, 0,
+	status = acpi_evaluate_object(pcc->handle, METHOD_HKEY_SINF, NULL,
 				      &buffer);
 	if (ACPI_FAILURE(status)) {
 		ACPI_DEBUG_PRINT((ACPI_DB_ERROR,

