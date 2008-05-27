Return-Path: <linux-kernel-owner+w=401wt.eu-S1758871AbYE0Pjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871AbYE0Pjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 11:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757411AbYE0PjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 11:39:07 -0400
Received: from www.tglx.de ([62.245.132.106]:51530 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757035AbYE0PjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 11:39:06 -0400
Date: Tue, 27 May 2008 17:36:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, paulus@samba.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] rcupreempt: remove export of rcu_batches_completed_bh
In-Reply-To: <Pine.LNX.4.58.0805221415330.14724@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.1.10.0805271735280.3295@apollo.tec.linutronix.de>
References: <Pine.LNX.4.58.0805221415330.14724@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008, Steven Rostedt wrote:
> In rcupreempt, rcu_batches_completed_bh is defined as a static inline in
> the header file. This does not need to be exported, and not only that,
> this breaks my PPC build.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>

Applied, queued for Linus. Thanks

	 tglx
