Return-Path: <linux-kernel-owner+w=401wt.eu-S1756481AbYLVXEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481AbYLVXEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 18:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbYLVXEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 18:04:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40675 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbYLVXEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 18:04:22 -0500
Message-ID: <49501CC9.5040507@zytor.com>
Date: Mon, 22 Dec 2008 15:03:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org, kenchen@google.com,
       paulus@samba.org, tglx@linutronix.de, linux-next@vger.kernel.org,
       David Miller <davem@davemloft.net>
Subject: Re: [patch] powerpc: change u64/s64 to a long long integer type
References: <20081222152247.b934ed5b.sfr@canb.auug.org.au> <b040c32a0812212249p45aba306tbb68a960b79cd0ee@mail.gmail.com> <20081222070426.GD29160@elte.hu> <20081222181932.5dd9514e.sfr@canb.auug.org.au> <20081222080341.GA18897@elte.hu> <20081222144319.1bfc0061.akpm@linux-foundation.org> <20081222230035.GB4074@uranus.ravnborg.org>
In-Reply-To: <20081222230035.GB4074@uranus.ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Mon, Dec 22, 2008 at 02:43:19PM -0800, Andrew Morton wrote:
>> On Mon, 22 Dec 2008 09:03:41 +0100
>> Ingo Molnar <mingo@elte.hu> wrote:
>>
>>> Subject: powerpc: change u64/s64 to a long long integer type
>> <applause>
>>
>> There are lots of other architctures that need doing though.
> 
> I have missed the introduction.
> Can you explain why?
> 
> I have done a bit of sparc hacking lately and was wondering if
> sparc needs something similar.
> 
> cd arch/sparc
> git grep u64 | grep -v __u64 | wc -l
> 448
> 

This should only affect 64-bit architectures.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

