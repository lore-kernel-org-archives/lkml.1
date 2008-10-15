Return-Path: <linux-kernel-owner+w=401wt.eu-S1752928AbYJOG7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbYJOG7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 02:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbYJOG6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 02:58:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60720 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbYJOG6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 02:58:52 -0400
Message-ID: <48F5942F.4080400@cn.fujitsu.com>
Date: Wed, 15 Oct 2008 14:56:47 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip/tracing/markers] markers: let marker_table be close to
 its comments
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


marker_table is defined far from its comments, this fix make
cleanup for it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/marker.c b/kernel/marker.c
index e9c6b2b..e49a9c5 100644
--- a/kernel/marker.c
+++ b/kernel/marker.c
@@ -43,6 +43,7 @@ static DEFINE_MUTEX(markers_mutex);
  */
 #define MARKER_HASH_BITS 6
 #define MARKER_TABLE_SIZE (1 << MARKER_HASH_BITS)
+static struct hlist_head marker_table[MARKER_TABLE_SIZE];
 
 /*
  * Note about RCU :
@@ -67,8 +68,6 @@ struct marker_entry {
 	char name[0];	/* Contains name'\0'format'\0' */
 };
 
-static struct hlist_head marker_table[MARKER_TABLE_SIZE];
-
 /**
  * __mark_empty_function - Empty probe callback
  * @probe_private: probe private data




