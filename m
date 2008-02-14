Return-Path: <linux-kernel-owner+w=401wt.eu-S1759440AbYBNQEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440AbYBNQEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 11:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755326AbYBNQDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 11:03:49 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:15536 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754891AbYBNQDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 11:03:48 -0500
Message-Id: <20080214155724.772744000@chello.nl>
User-Agent: quilt/0.45-1
Date: Thu, 14 Feb 2008 16:57:24 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Paul Jackson <pj@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 0/2] reworking load_balance_monitor
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here the current patches that rework load_balance_monitor.

The main reason for doing this is to eliminate the wakeups the thing generates,
esp. on an idle system. The bonus is that it removes a kernel thread.

Paul, Gregory - the thing that bothers me most atm is the lack of
rd->load_balance. Should I introduce that (-rt ought to make use of that as
well) by way of copying from the top sched_domain when it gets created?

 - peterz

