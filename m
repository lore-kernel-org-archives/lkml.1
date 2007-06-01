Return-Path: <linux-kernel-owner+w=401wt.eu-S1759972AbXFAGRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972AbXFAGRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 02:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757426AbXFAGRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 02:17:06 -0400
Received: from smtp-out.google.com ([216.239.45.13]:40101 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264AbXFAGRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 02:17:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=O525JWTqM42/LjHxpWUFgJyHVDLed/n+8alMM/fjzZAGP5efR7hsHqQMlBIgqVAnv
	IZjpF7cZEAbliKVwHoZVw==
Message-ID: <465FB9CD.2090000@google.com>
Date: Thu, 31 May 2007 23:16:45 -0700
From: Ethan Solomita <solo@google.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@google.com>, a.p.zijlstra@chello.nl
Subject: [RFC 6/7] cpuset write fixes
References: <465FB6CF.4090801@google.com>
In-Reply-To: <465FB6CF.4090801@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unneeded local variable.

Originally by Christoph Lameter <clameter@sgi.com>

Signed-off-by: Ethan Solomita <solo@google.com>

---

diff -uprN -X 0/Documentation/dontdiff 5/mm/page-writeback.c 6/mm/page-writeback.c
--- 5/mm/page-writeback.c	2007-05-30 11:37:01.000000000 -0700
+++ 6/mm/page-writeback.c	2007-05-30 11:39:25.000000000 -0700
@@ -177,7 +177,6 @@ get_dirty_limits(struct dirty_limits *dl
 	int unmapped_ratio;
 	long background;
 	long dirty;
-	unsigned long available_memory = determine_dirtyable_memory();
 	unsigned long dirtyable_memory;
 	unsigned long nr_mapped;
 	struct task_struct *tsk;

