Return-Path: <linux-kernel-owner+w=401wt.eu-S1757791AbYKVL3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791AbYKVL3K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 06:29:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756970AbYKVL2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 06:28:55 -0500
Received: from mu-out-0910.google.com ([209.85.134.185]:27440 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924AbYKVL2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 06:28:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=svY5AMgcwkYbVQgjFfCgBFKax8saMBt40dK6DsH9dlDPjyg8ppdPgUbX5vMSJxDEwt
         4IpVnLkZg6jWfAoCBvun8WWik9tiieDPCfoAlWAmdMhr3jsRVki4PAlOvmsLHBAjkC95
         WvOp3BkJTnqwmkS6NgaaMNTKPM72EZW5zsJkY=
From: =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
To: mingo@elte.hu
Cc: srostedt@redhat.com, a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
Subject: [PATCH 0/2] tracing: userspace stacktraces
Date: Sat, 22 Nov 2008 13:28:46 +0200
Message-Id: <1227353328-16104-1-git-send-email-edwintorok@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am resending my patches, differrences from previous send:
* fixed some style issues
* introduce seq_print_user_ip helper
* make mangle_path global and document
* use mangle_path instead of abusing seq_file in trace_seq_path
* fix subject line and commit messages

These patches apply on top of tip/master,
commit 50598e26c1360d4c0edcabc50035d084ee8d3d70

Török Edwin (2):
  tracing: add support for userspace stacktraces in tracing/iter_ctrl
  tracing: identify which executable object the userspace address
    belongs to

 Documentation/ftrace.txt     |   16 ++++-
 arch/x86/kernel/stacktrace.c |   57 +++++++++++++++
 fs/seq_file.c                |   14 ++++-
 include/linux/seq_file.h     |    1 +
 include/linux/stacktrace.h   |    8 ++
 kernel/trace/trace.c         |  165 ++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.h         |   10 +++
 7 files changed, 269 insertions(+), 2 deletions(-)

