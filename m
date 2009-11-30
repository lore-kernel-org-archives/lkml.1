Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbZK3HSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbZK3HSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 02:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbZK3HSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 02:18:50 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:60621 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbZK3HSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 02:18:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Z+936LzY5M9NCRaoSR5nFNfSyheJDKSH02tMoACRQ+lOwo7KVqLSQDqflhU+dre0Sz
         FVj6rB1oO2I5+1U72r1cHQKlrzAu/mKMLU+PSfYzH7qMEYQ0qVTusN6seiXDTv41B6Lt
         XKdKxJMSpoap1tYwVXDCtx1yb2lF0b1/o5xyw=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org, anton@samba.org,
       hch@infradead.org
Subject: [PATCH 0/4] Fixes for perf/scripting
Date: Mon, 30 Nov 2009 01:18:45 -0600
Message-Id: <1259565529-6407-1-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Zanussi (4):
  perf trace/scripting: silence PERL_EMBED_* backtick errors
  perf trace/scripting: ignore shadowed variable warning for
    perf-trace-perl.c
  perf trace/scripting: fix Perl common_* access functions
  perf trace/scripting: Add Fedora libperl install note to doc

 tools/perf/Makefile                                |    6 ++--
 tools/perf/scripts/perl/Perf-Trace-Util/Context.c  |   30 ++++++++++----------
 tools/perf/scripts/perl/Perf-Trace-Util/Context.xs |    6 ++--
 tools/perf/scripts/perl/Perf-Trace-Util/README     |    4 +-
 tools/perf/util/trace-event-perl.c                 |   10 ++++--
 tools/perf/util/trace-event-perl.h                 |    6 ++--
 6 files changed, 32 insertions(+), 30 deletions(-)

