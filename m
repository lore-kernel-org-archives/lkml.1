Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbYDJBBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbYDJBBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 21:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbYDJBBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 21:01:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59608 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbYDJBBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 21:01:09 -0400
Message-ID: <47FD6399.6030302@zytor.com>
Date: Wed, 09 Apr 2008 17:47:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Adrian Bunk <bunk@stusta.de>, Alexey Dobriyan <adobriyan@gmail.com>,
       akpm@osdl.org
Subject: Re: [patch 13/17] Immediate Values - x86 Optimization
References: <20080409150829.855195878@polymtl.ca> <20080409152051.117322728@polymtl.ca> <47FD0497.10303@zytor.com> <20080409190816.GB30202@Krystal> <47FD4442.3050000@zytor.com> <20080410004219.GA10557@Krystal>
In-Reply-To: <20080410004219.GA10557@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> Ok. Sorry, it's been a few months since we looked at this. So the =q
> opcode lets the compiler choose instructions with or without REX prefix.
> We can allow this because 
> 
> - We don't need the opcode length in the stop_machine_run() version
> - we support variable length opcode in the nmi-safe version
> 
> Am I remembering correctly now ?
> 

Yes.  Both =r and =q allow REX opcodes.

	-hpa
