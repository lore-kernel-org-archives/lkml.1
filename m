Return-Path: <linux-kernel-owner+w=401wt.eu-S1758062AbZCBT22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbZCBT22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 14:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbZCBT2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 14:28:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38797 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbZCBT2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 14:28:19 -0500
Message-ID: <49AC3221.4030506@zytor.com>
Date: Mon, 02 Mar 2009 11:23:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Arjan van de Ven <arjan@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC][PATCH] x86: make text_poke() atomic
References: <alpine.DEB.2.00.0902231125520.18221@gandalf.stny.rr.com>	<20090223173108.GB1441@Krystal>	<alpine.DEB.2.00.0902231236340.18221@gandalf.stny.rr.com>	<49A82851.5080707@redhat.com>	<20090227180724.GA17947@Krystal>	<49A83237.40604@redhat.com>	<20090227185316.GA19811@Krystal>	<49A853CD.3020607@redhat.com>	<49AC10E9.1090102@redhat.com>	<20090302102841.7e099670@infradead.org>	<20090302183617.GA25105@Krystal> <20090302105500.569e1270@infradead.org> <49AC2FDF.9070700@redhat.com>
In-Reply-To: <49AC2FDF.9070700@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
>>>
>>> Stop machine is not required when inserting a breakpoint. 
>>
>> that is your assumption; when I spoke with CPU architects they
>> cringed ;(
> 
> Is that true even if modifying just one-byte (like int3 insertion)
> and we don't care synchronous write(that means code modification
> effects on other processors after a while)?
> 

The problem is that he's using is as part of a sequenced series of 
steps.  The lack of synchronization comes into play there.

	-hpa

