Return-Path: <linux-kernel-owner+w=401wt.eu-S1758757AbYLLNl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757AbYLLNl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 08:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758127AbYLLNlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 08:41:51 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43572 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757040AbYLLNlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 08:41:50 -0500
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Tony Luck <tony.luck@intel.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch] Performance Counters for Linux, v3
From: Andi Kleen <andi@firstfloor.org>
References: <20081211155230.GA4230@elte.hu>
	<12c511ca0812111111t2992dd2cw8b4d57ac57bd0700@mail.gmail.com>
	<20081211193439.GA25986@elte.hu> <1229070570.12883.14.camel@twins>
Date: Fri, 12 Dec 2008 14:42:08 +0100
In-Reply-To: <1229070570.12883.14.camel@twins> (Peter Zijlstra's message of "Fri, 12 Dec 2008 09:29:30 +0100")
Message-ID: <8763lpcxxr.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> writes:
> On that, I still don't think its a good idea to use bitfields in an ABI.
> The C std is just not strict enough on them,

If you constrain yourself to a single architecture in practice C
bitfield standards are quite good e.g. on Linux/x86 it is "everyone
implements what gcc does" (and on linux/ppc "what ppc gcc does"). 
And the syscall ABI is certainly restricted to one architecture.

-Andi

-- 
ak@linux.intel.com
