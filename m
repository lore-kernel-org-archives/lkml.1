Return-Path: <linux-kernel-owner+w=401wt.eu-S1755752AbYBYA1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbYBYA1f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 19:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759791AbYBYAZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 19:25:38 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:3419 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341AbYBYAZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 19:25:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=I8xRflDXoTRzL5jqyO0GupioqT+YHSBIRsi0rVZn5SJazXNTWoeuytrWDtp9DPcgE6C9GeEcZ2jvV0pYR8V4hMxFTnUX6alpJc3ilwPdZjmV0lEkKen7IBvVDGRc2rFIGL04AFVnMmd7CXNNq6I5HI1Bz7juhCg4SNTe5RTtqYY=
Subject: [PATCH 4/6] smack: make functions static
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <5ce117613299590dd08d11d24d3a33d9077fe2b0.1203898924.git.harvey.harrison@gmail.com>
References: <5ce117613299590dd08d11d24d3a33d9077fe2b0.1203898924.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Sun, 24 Feb 2008 16:25:36 -0800
Message-Id: <1203899136.1767.9.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduced between 2.6.25-rc2 and -rc3
security/smack/smackfs.c:374:6: warning: symbol 'smk_unlbl_ambient' was not declared. Should it be static?

While here, take care of this one too.
security/smack/smackfs.c:341:6: warning: symbol 'smk_cipso_doi' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 security/smack/smackfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 358c92c..cb26951 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -338,7 +338,7 @@ static const struct file_operations smk_load_ops = {
 /**
  * smk_cipso_doi - initialize the CIPSO domain
  */
-void smk_cipso_doi(void)
+static void smk_cipso_doi(void)
 {
 	int rc;
 	struct cipso_v4_doi *doip;
@@ -371,7 +371,7 @@ void smk_cipso_doi(void)
 /**
  * smk_unlbl_ambient - initialize the unlabeled domain
  */
-void smk_unlbl_ambient(char *oldambient)
+static void smk_unlbl_ambient(char *oldambient)
 {
 	int rc;
 	struct netlbl_audit audit_info;
-- 
1.5.4.2.200.g99e75


