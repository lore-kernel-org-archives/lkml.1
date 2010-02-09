Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab0BIMNN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 07:13:13 -0500
Received: from mail-yx0-f193.google.com ([209.85.210.193]:65115 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab0BIMNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 07:13:12 -0500
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linux-kernel@vger.kernel.org
Cc: jaharkes@cs.cmu.edu, coda@cs.cmu.edu, codalist@TELEMANN.coda.cs.cmu.edu
Subject: [PATCH] coda: fix warning when CONFIG_SYSCTL is disabled
Date: Tue,  9 Feb 2010 10:12:54 -0200
Message-Id: <1265717574-26274-1-git-send-email-padovan@profusion.mobi>
X-Mailer: git-send-email 1.6.0.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/coda/sysctl.c:18: warning: ‘coda_table’ defined but not used

Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
---
 fs/coda/sysctl.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/coda/sysctl.c b/fs/coda/sysctl.c
index c6405ce..c4ccf15 100644
--- a/fs/coda/sysctl.c
+++ b/fs/coda/sysctl.c
@@ -13,7 +13,6 @@
 
 #ifdef CONFIG_SYSCTL
 static struct ctl_table_header *fs_table_header;
-#endif
 
 static ctl_table coda_table[] = {
 	{
@@ -40,7 +39,6 @@ static ctl_table coda_table[] = {
 	{}
 };
 
-#ifdef CONFIG_SYSCTL
 static ctl_table fs_table[] = {
 	{
 		.procname	= "coda",
-- 
1.6.4.4

