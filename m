Return-Path: <linux-kernel-owner+w=401wt.eu-S1758835AbYADIxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835AbYADIxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 03:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbYADIxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 03:53:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49681 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126AbYADIxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 03:53:38 -0500
Date: Fri, 4 Jan 2008 09:53:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [2/16] Add a counter for per cpu clocksource
	watchdog checks and report them in /proc/interrupts
Message-ID: <20080104085327.GB28740@elte.hu>
References: <20080103442.621670000@suse.de> <20080103154215.C793314DDB@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103154215.C793314DDB@wotan.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0010]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> While infrequent it's better if all per CPU events have a counter.
> 
> Only done for x86 currently.

while i agree with exposing this counter, /proc/interrupts is the wrong 
place for this - please add it to /proc/timer_list instead, that's where 
we put all the time related debug info - it already has per cpu printout 
sections. And that way it's much simpler as well. (no need to modify all 
the architectures)

	Ingo
