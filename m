Return-Path: <linux-kernel-owner+w=401wt.eu-S1757549AbZGGP0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbZGGP0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756388AbZGGPZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:25:36 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:46519 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756842AbZGGPZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:25:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=NqVBtDR6fPHYJwzHUGcnwM9D1jGEDFORaT9d5oUxsiK1T3PUwBzZ9ppuvAnpIFfHcZ
         7B9NwNX657pGD2wb9/+0kOpLBfNqNyCtK3bgNPa/5P8RPeJcfB5oR+VJdY5toqvkbFUR
         QHZQzsbJd+qcq57UzR21Pa2v8FrgGFf8bFm/M=
MIME-Version: 1.0
From: Joao Correia <joaomiguelcorreia@gmail.com>
Date: Tue, 7 Jul 2009 16:25:14 +0100
Message-ID: <a5d9929e0907070825p78c1e527ud8f8d047767f621e@mail.gmail.com>
Subject: [PATCH 3/3] Increase lockdep limits: MAX_LOCKDEP_CHAINS_BITS
To: LKML <linux-kernel@vger.kernel.org>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, a.p.zijlstra@chello.nl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Applies to current Linus tree, as of 2.6.31-rc2)

A third limit becomes apparent as being too low after raising
MAX_STACK_TRACE_ENTRIES and MAX_LOCK_DEPTH, although this one is more
elusive to trigger.


Signed-off-by: Joao Correia <joaomiguelcorreia@gmail.com>

---
 kernel/lockdep_internals.h | 2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index 699a2ac..93af1f1 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -56,7 +56,7 @@ enum {
  */
 #define MAX_LOCKDEP_ENTRIES    16384UL

-#define MAX_LOCKDEP_CHAINS_BITS        15
+#define MAX_LOCKDEP_CHAINS_BITS        16
 #define MAX_LOCKDEP_CHAINS     (1UL << MAX_LOCKDEP_CHAINS_BITS)

 #define MAX_LOCKDEP_CHAIN_HLOCKS (MAX_LOCKDEP_CHAINS*5)
---
