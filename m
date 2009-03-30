Return-Path: <linux-kernel-owner+w=401wt.eu-S1757968AbZC3RO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbZC3RO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 13:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbZC3RLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 13:11:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52299 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbZC3RLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 13:11:24 -0400
Message-Id: <20090330170701.856843742@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 30 Mar 2009 19:07:01 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 00/15] pending perf_counter bits
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the previous set, except I kept the powerpc set_perf_counter_pending()
bits.

This set also adds callchain support for x86 (no userspace yet -- am looking
at porting sysprof). Furthermore, it has a first attempt at making
perf_counters and oprofile and nmi_watchdog not stomp on each other.

New bits only compile tested on x86_64 and ppc64.
-- 

