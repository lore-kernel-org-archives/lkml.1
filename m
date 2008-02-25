Return-Path: <linux-kernel-owner+w=401wt.eu-S1758901AbYBYVPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901AbYBYVPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 16:15:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYBYVPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 16:15:45 -0500
Received: from n11.bullet.mail.mud.yahoo.com ([209.191.125.210]:37608 "HELO
	n11.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751174AbYBYVPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 16:15:44 -0500
X-Yahoo-Newman-Id: 736313.33294.bm@omp402.mail.mud.yahoo.com
X-YMail-OSG: P99nsugVM1nCqqZg7UFuFw4IuSpSoOaleC17eL4Ug3v6.RKmhZLgS0pMMQPtJ4cI78XhhCP17A--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <47C32FFA.2000605@schaufler-ca.com>
Date: Mon, 25 Feb 2008 13:15:38 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, casey@schaufler-ca.com
Subject: [PATCH] (02/25/08 linus git) smack functions smk_cipso_doi and smk_unlbl_ambient
 made static
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>

The functions smk_cipso_doi and smk_unlbl_ambient are not used
outside smackfs.c and should hence be static.


Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---

 security/smack/smackfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -uprN -X linux-2.6.25-g0225-base/Documentation/dontdiff linux-2.6.25-g0225-base/security/smack/smackfs.c linux-2.6.25-g0225/security/smack/smackfs.c
--- linux-2.6.25-g0225-base/security/smack/smackfs.c	2008-02-25 08:19:08.000000000 -0800
+++ linux-2.6.25-g0225/security/smack/smackfs.c	2008-02-25 12:06:21.000000000 -0800
@@ -338,7 +338,7 @@ static const struct file_operations smk_
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


