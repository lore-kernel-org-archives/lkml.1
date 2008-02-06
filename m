Return-Path: <linux-kernel-owner+w=401wt.eu-S1762853AbYBFMJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762853AbYBFMJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 07:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761254AbYBFMJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 07:09:29 -0500
Received: from gecko.sbs.de ([194.138.37.40]:24797 "EHLO gecko.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761968AbYBFMJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 07:09:29 -0500
Message-ID: <47A9A356.8080400@siemens.com>
Date: Wed, 06 Feb 2008 13:08:54 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Phil Oester <kernel@linuxace.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [git pull] x86 arch updates for v2.6.25
References: <20080130011550.GA31853@elte.hu>	<200802050436.31070.maximlevitsky@gmail.com>	<alpine.LFD.1.00.0802041922300.3237@woody.linux-foundation.org>	<20080205041103.GA11240@linuxace.com> <20080204205412.466a883c.akpm@linux-foundation.org>
In-Reply-To: <20080204205412.466a883c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 4 Feb 2008 20:11:03 -0800 Phil Oester <kernel@linuxace.com> wrote:
> 
>> On Mon, Feb 04, 2008 at 07:27:53PM -0800, Linus Torvalds wrote:
>>> kgdb? Not so interesting. We have many more hard problems happening at 
>>> user sites, not in developer hands.
>> FWIW, I'm not a fulltime developer by any means, but on occasion
>> I have fixed a few bugs in the netfilter area of the kernel.
>> And in almost all cases, I used kgdb in my debugging and testing
> 
>                                                            ^^^^^^^
>> of fixes.  
> 
> yup.

I can also underline this - and add the aspect that a kernel debugger
may also nicely serve to explore tricky code paths interactively. This
specifically can lower the entrance barrier to complex kernel subsystems
for new developers/bug hunters.

With the latest changes, now all available through Jason's git repos for
2.6.25, kgdb should be usable again ("Now even more stable than ever!"
;) ). It became much less invasive towards critical code paths during
recent rounds of refactoring, so we can hopefully meet the requirements
for merging it upstream soon (2.6.26?).

While too many people consider a debugger as _the_ tool for kernel
development, which it clearly isn't, it remains a fairly useful feature,
and I don't see any regression, technically or organizationally, it may
introduce to Linux. IMHO, it would be a pity if kgdb have to remain out
off tree and may potentially fall back at quality levels that many of us
had fought with in the past.

Jan

-- 
Siemens AG, Corporate Technology, CT SE 2
Corporate Competence Center Embedded Linux
