Return-Path: <linux-kernel-owner+w=401wt.eu-S1760038AbYEESYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760038AbYEESYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755700AbYEESXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:23:15 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54709 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755403AbYEESXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:23:04 -0400
Date: Mon, 5 May 2008 21:21:57 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Srinivasa Ds <srinivasa@in.ibm.com>, ananth@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       mhiramat@redhat.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] make kprobe_blacklist[] static
Message-ID: <20080505182157.GG17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global kprobe_blacklist[] static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
d43075ce223623b39e6971fb670cd4e4c8628c94 diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 1e0250c..26936b1 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -79,7 +79,7 @@ static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
  *
  * For such cases, we now have a blacklist
  */
-struct kprobe_blackpoint kprobe_blacklist[] = {
+static struct kprobe_blackpoint kprobe_blacklist[] = {
 	{"preempt_schedule",},
 	{NULL}    /* Terminator */
 };

