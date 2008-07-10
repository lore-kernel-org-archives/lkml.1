Return-Path: <linux-kernel-owner+w=401wt.eu-S1758282AbYGJQiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282AbYGJQiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 12:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbYGJQip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 12:38:45 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:55147 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbYGJQio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 12:38:44 -0400
Subject: [PATCH] kernel/kprobes.c: Made kprobe_blacklist static.
From: Daniel Guilak <guilak@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, daniel@danielguilak.com
Content-Type: text/plain
Date: Thu, 10 Jul 2008 09:38:19 -0700
Message-Id: <1215707899.6497.2.camel@dguilak-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Guilak <daniel@danielguilak.com>
---
 kernel/kprobes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index d4998f8..1485ca8 100644
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
-- 
1.5.4.3


