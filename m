Return-Path: <linux-kernel-owner+w=401wt.eu-S1753581AbZFAVi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbZFAVi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbZFAViX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:38:23 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:53324 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbZFAViW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 17:38:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18980.19019.158462.125715@cargo.ozlabs.ibm.com>
Date: Tue, 2 Jun 2009 07:38:19 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counter: Provide functions for locking and
	pinning the context for a task
In-Reply-To: <20090601162109.GA8459@elte.hu>
References: <18979.34748.755674.596386@cargo.ozlabs.ibm.com>
	<18979.35192.995732.609215@cargo.ozlabs.ibm.com>
	<20090601162109.GA8459@elte.hu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> -tip testing found that these patches are causing a crash:

Argh.  What was userspace doing at the time of the crash, do you know?
It looks like it might have been on/off-lining a cpu, judging by the
stack trace.  Would there have been any counters attached to the task
doing there, or were there any per-cpu counters active?

Paul.
