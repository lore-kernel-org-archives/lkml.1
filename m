Return-Path: <linux-kernel-owner+w=401wt.eu-S1758732AbZFNONX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732AbZFNONX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 10:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754799AbZFNONO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 10:13:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:56198 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbZFNONO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 10:13:14 -0400
Date: Sun, 14 Jun 2009 14:12:32 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, efault@gmx.de, arjan@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       a.p.zijlstra@chello.nl, efault@gmx.de, arjan@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf record/report: Add call graph / call chain profiling
Message-ID: <tip-ced7769616b40c7a0d597af775d4f123fb54dc95@git.kernel.org>
Git-Commit-ID: ced7769616b40c7a0d597af775d4f123fb54dc95
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 14 Jun 2009 14:12:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ced7769616b40c7a0d597af775d4f123fb54dc95
Gitweb:     http://git.kernel.org/tip/ced7769616b40c7a0d597af775d4f123fb54dc95
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 14 Jun 2009 15:04:15 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Jun 2009 15:04:15 +0200

perf record/report: Add call graph / call chain profiling

Add the first steps of call-graph profiling:

 - add the -c (--call-graph) option to perf record
 - parse the call-graph record and printout out under -D (--dump-trace)

The call-graph data is not put into the histogram yet, but it
can be seen that it's being processed correctly:

0x3ce0 [0x38]: event: 35
