Return-Path: <linux-kernel-owner+w=401wt.eu-S1756115AbZETT6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbZETT6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 15:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755918AbZETT6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 15:58:09 -0400
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:3714 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453AbZETT6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 15:58:06 -0400
From: Alberto Bertogli <albertito@blitiri.com.ar>
To: linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
       trivial@kernel.org, Alberto Bertogli <albertito@blitiri.com.ar>
Subject: [PATCH 1/4] Fix minor typos in jbd2's journal.c
Date: Wed, 20 May 2009 16:01:31 -0300
Message-Id: <1242846091-1086-1-git-send-email-albertito@blitiri.com.ar>
X-Mailer: git-send-email 1.6.2.2.646.gb214
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
---
 fs/jbd2/journal.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 5814410..85af8ea 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1781,7 +1781,7 @@ int jbd2_journal_wipe(journal_t *journal, int write)
  * Journal abort has very specific semantics, which we describe
  * for journal abort.
  *
- * Two internal function, which provide abort to te jbd layer
+ * Two internal function, which provide abort to the jbd layer
  * itself are here.
  */
 
@@ -1879,7 +1879,7 @@ void jbd2_journal_abort(journal_t *journal, int errno)
  * int jbd2_journal_errno () - returns the journal's error state.
  * @journal: journal to examine.
  *
- * This is the errno numbet set with jbd2_journal_abort(), the last
+ * This is the errno number set with jbd2_journal_abort(), the last
  * time the journal was mounted - if the journal was stopped
  * without calling abort this will be 0.
  *
@@ -1903,7 +1903,7 @@ int jbd2_journal_errno(journal_t *journal)
  * int jbd2_journal_clear_err () - clears the journal's error state
  * @journal: journal to act on.
  *
- * An error must be cleared or Acked to take a FS out of readonly
+ * An error must be cleared or acked to take a FS out of readonly
  * mode.
  */
 int jbd2_journal_clear_err(journal_t *journal)
@@ -1923,7 +1923,7 @@ int jbd2_journal_clear_err(journal_t *journal)
  * void jbd2_journal_ack_err() - Ack journal err.
  * @journal: journal to act on.
  *
- * An error must be cleared or Acked to take a FS out of readonly
+ * An error must be cleared or acked to take a FS out of readonly
  * mode.
  */
 void jbd2_journal_ack_err(journal_t *journal)
-- 
1.6.2.2.646.gb214

