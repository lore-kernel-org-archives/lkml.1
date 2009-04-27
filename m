Return-Path: <linux-kernel-owner+w=401wt.eu-S1751143AbZD0EGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143AbZD0EGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 00:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750800AbZD0EGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 00:06:32 -0400
Received: from mail-qy0-f112.google.com ([209.85.221.112]:51647 "EHLO
	mail-qy0-f112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbZD0EGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 00:06:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=OBSC7auN422A6KwApKJivkoOrKAkCfz5OpAMcFLpq7tWGXObOraEH6cfmxjOpaE1Ec
         Nwh1SohO7vKcr+nRfCus2d2JITKbgP3aOf+cMVZ0NmC6XnsDFFNS8uik76q387n32tjW
         zesYe1i37bymFKq6G6kpF/Bbyq1U37aT/ydb4=
Date: Mon, 27 Apr 2009 12:43:33 +0900
From: Hitoshi Mitake <h.mitake@gmail.com>
To: dwmw2@infradead.org, jaharkes@cs.cmu.edu, linux-kernel@vger.kernel.org
Subject: [PATCH] ihex2fw should be ignored by scripts/.gitignore because
 ihex2fw is in scripts directory
Message-Id: <20090427124333.a7270ddf.h.mitake@gmail.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I found this message from git-status on not modified clone of Linus's tree,

# Not currently on any branch.
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#
#       scripts/ihex2fw
nothing added to commit but untracked files present (use "git add" to track)

This isn't a something fatal.
But I think this is not comfortable.

So I wrote the little patch to fix this. Please use.

Signed-off-by: Hitoshi Mitake <h.mitake@gmail.com>

---
 firmware/.gitignore |    2 +-
 scripts/.gitignore  |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/firmware/.gitignore b/firmware/.gitignore
index d9c6901..e292d92 100644
--- a/firmware/.gitignore
+++ b/firmware/.gitignore
@@ -3,4 +3,4 @@
 *.bin
 *.csp
 *.dsp
-ihex2fw
+
diff --git a/scripts/.gitignore b/scripts/.gitignore
index b939fbd..52cab46 100644
--- a/scripts/.gitignore
+++ b/scripts/.gitignore
@@ -7,3 +7,4 @@ pnmtologo
 bin2c
 unifdef
 binoffset
+ihex2fw
-- 
1.5.6.5

