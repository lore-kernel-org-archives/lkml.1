Return-Path: <linux-kernel-owner+w=401wt.eu-S934093AbZKYHPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934093AbZKYHPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 02:15:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757896AbZKYHPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 02:15:04 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:36833 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbZKYHPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 02:15:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nIJniiAO3v3SZeqkFzfKuAFsbfv564pIl77punp2mf+hq8h6JKOuzAt9CCkzPnnAGc
         TdcXMD+AqoX3xGtFW6g/LfrnHvPUyvEXfs6fr11E4z4EGHhtR1D1jiADgZ0sG2I5zmAn
         YmjZb5ngaX0zmUFqG4dFj0jQAzPocHUWCSQ7o=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org
Subject: [PATCH 2/2] trace/syscalls: Change ret param in struct syscall_trace_exit to long
Date: Wed, 25 Nov 2009 01:14:59 -0600
Message-Id: <1259133299-23594-3-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1259133299-23594-1-git-send-email-tzanussi@gmail.com>
References: <1259133299-23594-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ee949a86b3aef15845ea677aa60231008de62672 changed the syscall
exit return type to long, but forgot to change it in the struct.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 kernel/trace/trace.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 5d6398b..ea5dda4 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -100,7 +100,7 @@ struct syscall_trace_enter {
 struct syscall_trace_exit {
 	struct trace_entry	ent;
 	int			nr;
-	unsigned long		ret;
+	long			ret;
 };
 
 struct kprobe_trace_entry {
-- 
1.6.4.GIT

