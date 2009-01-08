Return-Path: <linux-kernel-owner+w=401wt.eu-S1760185AbZAHUdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185AbZAHUdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbZAHUdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 15:33:04 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:42723 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbZAHUdC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 15:33:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=ru+SxoMlXgENN8vGvPNqoJ3nVrOzdsLzIwxn0DjXMfsuS9rp880xzkFUwVMz1F4CFw
         gA9yh0HeAIe0XMDKOhL1aHQD/aMgS+TbMaRYR5jn0pBxhhpwvS3X2A/NOlGdYcueV9js
         ZiO6vF3JPXzKPJGxIi0Dk5OqDJcHd+uCQn1jM=
Date: Thu, 8 Jan 2009 22:32:55 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, pq@iki.fi
Subject: [PATCH 1/3] doc: update mmiotrace.txt
Message-ID: <20090108223255.6f29f1cf@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 32fe58c5a4a162e9d6ab4aca91692e0e28167f97 Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Sat, 3 Jan 2009 21:09:27 +0200
Subject: [PATCH] doc: update mmiotrace.txt

The tracing framework buffer size file in debugfs has changed.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---

Ingo, I'm hoping these three patches would make it into .29.
Thanks.

 Documentation/tracers/mmiotrace.txt |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/Documentation/tracers/mmiotrace.txt b/Documentation/tracers/mmiotrace.txt
index cde23b4..5731c67 100644
--- a/Documentation/tracers/mmiotrace.txt
+++ b/Documentation/tracers/mmiotrace.txt
@@ -78,12 +78,10 @@ to view your kernel log and look for "mmiotrace has lost events" warning. If
 events were lost, the trace is incomplete. You should enlarge the buffers and
 try again. Buffers are enlarged by first seeing how large the current buffers
 are:
-$ cat /debug/tracing/trace_entries
+$ cat /debug/tracing/buffer_size_kb
 gives you a number. Approximately double this number and write it back, for
 instance:
-$ echo 0 > /debug/tracing/tracing_enabled
-$ echo 128000 > /debug/tracing/trace_entries
-$ echo 1 > /debug/tracing/tracing_enabled
+$ echo 128000 > /debug/tracing/buffer_size_kb
 Then start again from the top.
 
 If you are doing a trace for a driver project, e.g. Nouveau, you should also
-- 
1.6.0.6

