Return-Path: <linux-kernel-owner+w=401wt.eu-S1756623AbYEPTfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbYEPTfO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 15:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbYEPTfC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 15:35:02 -0400
Received: from www.tglx.de ([62.245.132.106]:58860 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbYEPTfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 15:35:00 -0400
Date: Fri, 16 May 2008 21:32:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Stas Sergeev <stsp@aknet.ru>,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: [Bugme-new] [Bug 10701] New: snd_pcsp lockdep warning
In-Reply-To: <20080516103827.0d5ab023.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805162132050.3255@apollo.tec.linutronix.de>
References: <bug-10701-10286@http.bugzilla.kernel.org/> <20080515110244.6e15d4c3.akpm@linux-foundation.org> <alpine.LFD.1.10.0805161338500.3255@apollo.tec.linutronix.de> <20080516103827.0d5ab023.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2008, Andrew Morton wrote:
> > So the author was well aware of locking problem and the whole code is
> > just a stupid hack around the problem without solving it. This code is
> > not at all suited for HRTIMER_CB_IRQSAFE.
> 
> You sound impressed!  So what's the fix?  HRTIMER_CB_SOFTIRQ?

Yeah, impressed by creativity. HRTIMER_CB_SOFTIRQ should be the right
thing.

Thanks,
	tglx

