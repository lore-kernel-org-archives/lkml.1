Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbYHMS5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbYHMS5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 14:57:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbYHMS4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 14:56:54 -0400
Received: from il.qumranet.com ([212.179.150.194]:39261 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbYHMS4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:56:54 -0400
Message-ID: <48A32E77.2000505@qumranet.com>
Date: Wed, 13 Aug 2008 21:56:55 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: Efficient x86 and x86_64 NOP microbenchmarks
References: <alpine.DEB.1.10.0808081750590.16691@gandalf.stny.rr.com> <87tzdv2g05.fsf@basil.nowhere.org> <alpine.DEB.1.10.0808082030500.1396@gandalf.stny.rr.com> <489CE90D.1040902@goop.org> <alpine.LFD.1.10.0808081750060.3462@nehalem.linux-foundation.org> <alpine.DEB.1.10.0808082113090.3707@gandalf.stny.rr.com> <20080813175213.GA8679@Krystal> <alpine.LFD.1.10.0808131119290.3462@nehalem.linux-foundation.org> <20080813184142.GM1366@one.firstfloor.org> <48A32BCF.40300@qumranet.com> <20080813185110.GP1366@one.firstfloor.org>
In-Reply-To: <20080813185110.GP1366@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> How would you deal with inlines?  Using debug information?
>>     
>
> -pg already ignores inlines, so they aren't even traced today.
>
> It pretty much has to, assume an inline gets spread out by
> the global optimizer over the rest of the function, where would
> the mcount calls be inserted?
>   

Good point.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

