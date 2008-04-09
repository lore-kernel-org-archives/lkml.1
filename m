Return-Path: <linux-kernel-owner+w=401wt.eu-S1757103AbYDISQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103AbYDISQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 14:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbYDISQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 14:16:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48387 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbYDISQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 14:16:24 -0400
Message-ID: <47FD0497.10303@zytor.com>
Date: Wed, 09 Apr 2008 11:01:59 -0700
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
References: <20080409150829.855195878@polymtl.ca> <20080409152051.117322728@polymtl.ca>
In-Reply-To: <20080409152051.117322728@polymtl.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Ok, so the most flexible solution that I see, that should fit for both
> x86 and x86_64 would be :
> 1 byte  :       "=q" : "a", "b", "c", or "d" register for the i386.  For
>                        x86-64 it is equivalent to "r" class (for 8-bit
>                        instructions that do not use upper halves).
> 2, 4, 8 bytes : "=r" : A register operand is allowed provided that it is in a
>                        general register.

Any reason to keep carrying this completely misleading comment chunk still?

	-hpa
