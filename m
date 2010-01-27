Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163Ab0A0OMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab0A0OMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 09:12:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017Ab0A0OMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 09:12:05 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:31450 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab0A0OMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 09:12:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=NOQPQbTfxGoFiM5mbxp3d2NQY3BUXlmKg8WZPAT5gUzbZb6m0yMfKmLYgPlre1H3XE
         cEqG5KT1N/nfbnRQ17MVyWSWpZugnO3YMwbRr6lzsquAb5cVTbgUjEoUvPfjc+wo1Sx5
         Q38MBopwgu0yoVGoIhbJPVlVDQI22DbLhM6xQ=
From: John Kacur <jkacur@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>
Subject: [PATCH] perf: Ignore perf-archive
Date: Wed, 27 Jan 2010 15:11:54 +0100
Message-Id: <1264601514-9287-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tell git to ignore perf-archive.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 tools/perf/.gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index 124760b..e1d60d7 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -14,6 +14,7 @@ perf*.html
 common-cmds.h
 perf.data
 perf.data.old
+perf-archive
 tags
 TAGS
 cscope*
-- 
1.6.0.6

