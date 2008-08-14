Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbYHNRtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbYHNRtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 13:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbYHNRtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 13:49:35 -0400
Received: from gw.goop.org ([64.81.55.164]:50396 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577AbYHNRte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 13:49:34 -0400
Message-ID: <48A4700F.6030806@goop.org>
Date: Thu, 14 Aug 2008 10:49:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Steven Rostedt <srostedt@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC PATCH] x86 alternatives : fix LOCK_PREFIX race with	preemptible
 kernel and CPU hotplug
References: <20080813193715.GQ1366@one.firstfloor.org> <20080813200119.GA18966@Krystal> <20080813234156.GA25775@Krystal> <48A375E3.9090609@zytor.com> <48A388CE.2020404@goop.org> <20080814014944.GA31883@Krystal> <48A3A806.8060509@goop.org> <20080814151805.GA29507@Krystal> <48A465BA.5050406@goop.org> <48A468F5.4050308@zytor.com> <20080814174612.GB4697@Krystal>
In-Reply-To: <20080814174612.GB4697@Krystal>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Here are the specs. It's a brand new 64bits dual quad-core (Christmas in
> August) :-) None of the specs seems to talk about neither Core2 or
> Pentium 4 though. Those appellations seems to hold for desktop
> processors, not server processors...
>   

Is it a Dell thingy?  Turns out my main test box has exactly the same 
processor.

    J
