Return-Path: <linux-kernel-owner+w=401wt.eu-S1751893AbZFTFGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbZFTFGW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 01:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750871AbZFTFGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 01:06:14 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:60222 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbZFTFGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 01:06:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZytsQK/Gf8x44sChYdrRZrrpKrkjQ0L7nTX4kYB6c0Bp2mpq/47160j46jC2Bv0XBS
         udM2y7rfl0k5dy5X/miOQ7+i3Uq7urOYCIfajboJZHut0+xtz4uOc9w1vSFzOHryHwEf
         JH3N7OOmdPGNV7a+jwq1kOyT2y2rA0ScAjS9s=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 0/2] tracing/urgent: fixes for nop patching omissions
Date: Sat, 20 Jun 2009 07:06:10 +0200
Message-Id: <1245474372-5249-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Steven,

The first patch in the set fixes a bug on which ftrace silently
ommitted to recover nop patching after function tracing.

The issue is present in .31 and .30 as well

The second patch just adds a warning to prevent further mistakes like
that.

Thanks.

Frederic Weisbecker (2):
  tracing/urgent: fix unbalanced ftrace_start_up
  tracing/urgent: warn in case of ftrace_start_up inbalance

 kernel/trace/ftrace.c          |    7 +++++++
 kernel/trace/trace_functions.c |    8 +++++---
 2 files changed, 12 insertions(+), 3 deletions(-)

The following changes since commit 44ad18e0a65e296b2e68a1452509f6222cdce743:
  Steven Rostedt (1):
        tracing: update sample event documentation

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/urgent

Frederic Weisbecker (2):
      tracing/urgent: fix unbalanced ftrace_start_up
      tracing/urgent: warn in case of ftrace_start_up inbalance

 kernel/trace/ftrace.c          |    7 +++++++
 kernel/trace/trace_functions.c |    8 +++++---
 2 files changed, 12 insertions(+), 3 deletions(-)
