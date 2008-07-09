Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbYGIETI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbYGIETI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 00:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbYGIES2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 00:18:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59769 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbYGIES1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 00:18:27 -0400
Message-Id: <20080709041530.668120406@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 00:15:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] [PATCH] more sched_clock updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ftrace is still seeing jumps in the sched_clock.c code that is not seen in
using sched_clock() function itself. The following patches fix some of
the issues that I've seen. There is still a slight drift but all my attempts
to remove it completely have failed. Patch 3 does the best sofar at
keeping the jumps to a minimum.

-- Steve

