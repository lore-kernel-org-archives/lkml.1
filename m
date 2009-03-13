Return-Path: <linux-kernel-owner+w=401wt.eu-S1757687AbZCMLXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbZCMLXx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 07:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbZCMLXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 07:23:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46678 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbZCMLXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 07:23:40 -0400
Message-Id: <20090313112125.886730125@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 13 Mar 2009 12:21:25 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, paulus@samba.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 00/11] generic software counters -v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set improves the current software counters by providing sampling
events for most of them.

The clock based software counters use hrtimers to generate events, allowing
sample based profiling without hardware support -- obviously this has limited
functionality for kernal based profiling since we disable interrupts quite
frequently, but should be good for userspace.

Other events like pagefaults insert simple hooks into the actual pagefault
code to generate these events.

Future work (in-progress) will hook into the tracepoint infrastructure to to
provide profiling events.


