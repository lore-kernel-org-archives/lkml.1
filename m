Return-Path: <linux-kernel-owner+w=401wt.eu-S933044AbZKXOfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044AbZKXOfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 09:35:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932983AbZKXOfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 09:35:03 -0500
Received: from mail-qy0-f192.google.com ([209.85.221.192]:34500 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932981AbZKXOfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 09:35:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=UKOsDGxSc1SeIHQymY6akUmNIXDttONmUS0ymP5rOVkgb16qf2RjprFH49Gq/Z2kbo
         4im82gZQICJWmTwvxpHYxuhE9hQzjrBi6/+8k/6LUvOxHIX74Oe45NcvggOx33k0mN0z
         1ZN8TLswl2uVtoMsORHMiUNVibEjzMHiMSS3c=
From: John Kacur <jkacur@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, acme@redhat.com,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH] Perf-tools create common process_event functions
Date: Tue, 24 Nov 2009 15:34:59 +0100
Message-Id: <1259073301-11506-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This continues the effort to prevent bit-rot in perf-annotate by using
common functions for perf-report and perf-annotate where possible.

This creates the process.[ch] files.
More functions can be added here after - but this is a working step
in the process.

John Kacur (2):
  perf-tools: Add perf.data to .gitignore
  perf-tools: Use common process_event functions for annotate and
    report

 tools/perf/.gitignore            |    1 +
 tools/perf/Makefile              |    2 +
 tools/perf/builtin-annotate.c    |   56 +--------------------------------
 tools/perf/builtin-report.c      |   63 +------------------------------------
 tools/perf/util/process_event.c  |   53 +++++++++++++++++++++++++++++++
 tools/perf/util/process_event.h  |   29 +++++++++++++++++
 tools/perf/util/process_events.c |   64 ++++++++++++++++++++++++++++++++++++++
 tools/perf/util/process_events.h |   35 ++++++++++++++++++++
 8 files changed, 187 insertions(+), 116 deletions(-)
 create mode 100644 tools/perf/util/process_event.c
 create mode 100644 tools/perf/util/process_event.h
 create mode 100644 tools/perf/util/process_events.c
 create mode 100644 tools/perf/util/process_events.h

