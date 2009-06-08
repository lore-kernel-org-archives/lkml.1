Return-Path: <linux-kernel-owner+w=401wt.eu-S1757059AbZFHT1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059AbZFHT1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbZFHTXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:23:33 -0400
Received: from thunk.org ([69.25.196.29]:39558 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754771AbZFHTXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:16 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: Alberto Bertogli <albertito@blitiri.com.ar>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 43/49] jbd2: Fix minor typos in comments in fs/jbd2/journal.c
Date: Mon,  8 Jun 2009 15:23:01 -0400
Message-Id: <1244488987-32564-44-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-43-git-send-email-tytso@mit.edu>
References: <1244488987-32564-1-git-send-email-tytso@mit.edu>
 <1244488987-32564-2-git-send-email-tytso@mit.edu>
 <1244488987-32564-3-git-send-email-tytso@mit.edu>
 <1244488987-32564-4-git-send-email-tytso@mit.edu>
 <1244488987-32564-5-git-send-email-tytso@mit.edu>
 <1244488987-32564-6-git-send-email-tytso@mit.edu>
 <1244488987-32564-7-git-send-email-tytso@mit.edu>
 <1244488987-32564-8-git-send-email-tytso@mit.edu>
 <1244488987-32564-9-git-send-email-tytso@mit.edu>
 <1244488987-32564-10-git-send-email-tytso@mit.edu>
 <1244488987-32564-11-git-send-email-tytso@mit.edu>
 <1244488987-32564-12-git-send-email-tytso@mit.edu>
 <1244488987-32564-13-git-send-email-tytso@mit.edu>
 <1244488987-32564-14-git-send-email-tytso@mit.edu>
 <1244488987-32564-15-git-send-email-tytso@mit.edu>
 <1244488987-32564-16-git-send-email-tytso@mit.edu>
 <1244488987-32564-17-git-send-email-tytso@mit.edu>
 <1244488987-32564-18-git-send-email-tytso@mit.edu>
 <1244488987-32564-19-git-send-email-tytso@mit.edu>
 <1244488987-32564-20-git-send-email-tytso@mit.edu>
 <1244488987-32564-21-git-send-email-tytso@mit.edu>
 <1244488987-32564-22-git-send-email-tytso@mit.edu>
 <1244488987-32564-23-git-send-email-tytso@mit.edu>
 <1244488987-32564-24-git-send-email-tytso@mit.edu>
 <1244488987-32564-25-git-send-email-tytso@mit.edu>
 <1244488987-32564-26-git-send-email-tytso@mit.edu>
 <1244488987-32564-27-git-send-email-tytso@mit.edu>
 <1244488987-32564-28-git-send-email-tytso@mit.edu>
 <1244488987-32564-29-git-send-email-tytso@mit.edu>
 <1244488987-32564-30-git-send-email-tytso@mit.edu>
 <1244488987-32564-31-git-send-email-tytso@mit.edu>
 <1244488987-32564-32-git-send-email-tytso@mit.edu>
 <1244488987-32564-33-git-send-email-tytso@mit.edu>
 <1244488987-32564-34-git-send-email-tytso@mit.edu>
 <1244488987-32564-35-git-send-email-tytso@mit.edu>
 <1244488987-32564-36-git-send-email-tytso@mit.edu>
 <1244488987-32564-37-git-send-email-tytso@mit.edu>
 <1244488987-32564-38-git-send-email-tytso@mit.edu>
 <1244488987-32564-39-git-send-email-tytso@mit.edu>
 <1244488987-32564-40-git-send-email-tytso@mit.edu>
 <1244488987-32564-41-git-send-email-tytso@mit.edu>
 <1244488987-32564-42-git-send-email-tytso@mit.edu>
 <1244488987-32564-43-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alberto Bertogli <albertito@blitiri.com.ar>

Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
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
1.6.3.2.1.gb9f7d.dirty

