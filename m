Return-Path: <linux-kernel-owner+w=401wt.eu-S934331AbZIDVmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934331AbZIDVmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 17:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934277AbZIDVmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 17:42:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:10409 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934058AbZIDVmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 17:42:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=faaPQ7p1R+7gyWYUtZcqD2WThnBe2JKVWMX4qGNCwVvurUtBLArm2M9xACeL73FHju
         hok7SJRBCvegKmV0YZylnhsvvm6XCEy6ca8z4E+VNBiVIxCg+CM+TSogwZUc8i7hCBu9
         Rm0P7IUH9ARrCQVGycN7Oj+snqRMEf5fPJgEg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>
Subject: [PATCH 0/2] tracing: Fixes for 2.6.32
Date: Fri,  4 Sep 2009 23:42:15 +0200
Message-Id: <1252100537-7783-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull these two tracing fixes which can be found at

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git \
	tracing/core

Thanks.

---
Albin Tonnerre (1):
      tracing: Remove mentioning of legacy latency_trace file from documentation

Li Zefan (1):
      tracing/filters: Defer pred allocation, fix memory leak

 Documentation/trace/ftrace.txt     |   68 +++++++++++++++++++-----------------
 kernel/trace/trace_events_filter.c |   11 +++---
 2 files changed, 42 insertions(+), 37 deletions(-)
