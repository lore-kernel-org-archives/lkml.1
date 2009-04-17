Return-Path: <linux-kernel-owner+w=401wt.eu-S1759553AbZDQGjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553AbZDQGjr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 02:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225AbZDQGjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 02:39:35 -0400
Received: from gw.goop.org ([64.81.55.164]:56716 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754244AbZDQGje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 02:39:34 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: mathieu.desnoyers@polymtl.ca
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC] WIP pvops trace events
Date: Thu, 16 Apr 2009 23:39:29 -0700
Message-Id: <1239950374-1252-1-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is my series of pvops tracing patches, consisting of:

- Split out asm/paravirt_type.h from asm/paravirt.h, so that
  trace/events/pvops.h can include the types without getting everything
  else.

- Add a pile of new trace events, and insert them into asm/paravirt.h

- misc tidyups

This nearly compiles, except for some duplicate kmemtrace event
definitions, which I don't understand at all yet.

	J

 arch/x86/include/asm/paravirt.h       |  874 ++++---------------------
 arch/x86/include/asm/paravirt_types.h |  719 ++++++++++++++++++++
 arch/x86/kernel/Makefile              |    5 
 arch/x86/kernel/paravirt-trace.c      |   18 
 include/trace/events/pvops.h          | 1183 ++++++++++++++++++++++++++++++++++
 5 files changed, 2067 insertions(+), 732 deletions(-)

