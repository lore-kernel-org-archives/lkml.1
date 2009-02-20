Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbZBTWZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbZBTWZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 17:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbZBTWZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 17:25:49 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:6498 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbZBTWZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 17:25:49 -0500
Subject: Re: [Announce] 2.6.29-rc4-rt2
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
To: Thomas Gleixner <tglx@linutronix.de>, peterz@infradead.org
Cc: Thomas Gleixner <tglx@tglx.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 20 Feb 2009 14:25:43 -0800
Message-Id: <1235168743.1052.16.camel@quadrophenia.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 23:56 +0100, Thomas Gleixner wrote:
> We are pleased to announce the first update to our new preempt-rt
> series. It fixes the reported bugs and some more.
> 
FYI:

These patches in RT2:

rt-fix-ipi-kfree-introduce-ipi_softirq.patch
rt-fix-ipi-kfree-introduce-ipi_softirq-cleanup.patch

Cause a hard-lock when running dhcp on my 8-way AMD box.

Reverting them eliminates the issue.

Sven



