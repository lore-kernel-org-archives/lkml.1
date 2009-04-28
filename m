Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbZD1T3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbZD1T3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 15:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754430AbZD1T2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 15:28:07 -0400
Received: from relay.pcl-ipout01.plus.net ([212.159.7.99]:22088 "EHLO
	relay.pcl-ipout01.plus.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754428AbZD1T2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 15:28:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAL/z9knUnw4R/2dsb2JhbAC/J5Agg3MF
From: Stuart Bennett <stuart@freedesktop.org>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] mmiotrace: various fixes and cleaning
Date: Tue, 28 Apr 2009 20:17:47 +0100
Message-Id: <1240946271-7083-1-git-send-email-stuart@freedesktop.org>
X-Mailer: git-send-email 1.5.4.4
X-Plusnet-Relay: 29b9c11a9ac7c02b231b420490e13266
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all, this set contains one bug fix, a couple of cleanups, and a better fix
to the mmiotrace+gdb issue

Pekka Paalanen has kindly reviewed and acked all the changes.

It has been tested on 2.6.30-rc3 using a 32 bit processor and tracing the
proprietary Nvidia driver, and also builds cleanly on today's tip/master on
a 64 bit system

Stuart

Stuart Bennett (4):
      x86 mmiotrace: fix range test
      x86 mmiotrace: code consistency/legibility improvement
      x86 mmiotrace: refactor clearing/restore of page presence
      x86 mmiotrace: only register for die notifier when tracer active

 arch/x86/mm/kmmio.c       |  100 ++++++++++++++++++++++++++-------------------
 arch/x86/mm/mmio-mod.c    |    2 +
 include/linux/mmiotrace.h |    2 +
 3 files changed, 62 insertions(+), 42 deletions(-)
