Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbZLIQBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbZLIQBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 11:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbZLIQBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 11:01:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650AbZLIQBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 11:01:19 -0500
Date: Wed, 9 Dec 2009 16:55:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] "fair" rw spinlocks
Message-ID: <20091209155512.GB13192@redhat.com>
References: <20091130174638.GA9782@elte.hu> <alpine.LFD.2.00.0911302206370.24119@localhost.localdomain> <1259616429.26472.499.camel@laptop> <alpine.LFD.2.00.0911302300550.24119@localhost.localdomain> <alpine.LFD.2.00.0911301409560.2872@localhost.localdomain> <alpine.LFD.2.00.0911302328350.24119@localhost.localdomain> <alpine.LFD.2.00.0911301443110.2872@localhost.localdomain> <m1y6lg7q3n.fsf@fess.ebiederm.org> <20091207183226.GA20139@redhat.com> <1260218320.3935.723.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260218320.3935.723.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07, Peter Zijlstra wrote:
>
> Didn't Thomas and you also come up with a scheme to push most signal
> processing into task context?

We discussed another case (posix timers), this doesn't involve tasklist.
Oh, and stilll lacks a solution :/

Oleg.

