Return-Path: <linux-kernel-owner+w=401wt.eu-S1758686AbYAJWbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686AbYAJWbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 17:31:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbYAJWb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 17:31:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50419 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbYAJWbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 17:31:25 -0500
Message-ID: <47869C93.2060308@zytor.com>
Date: Thu, 10 Jan 2008 14:30:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Matthew <jackdachef@gmail.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ed Tomlinson <edt@aei.ca>
Subject: Re: Fwd: Fwd: laptop / computer hardlocks during execution of 32bit
 applications(binaries) on 64bit system (Gentoo)
References: <e85b9d30712291157v113f5e73yd830ae3c3429092d@mail.gmail.com>	 <200712300128.35476.mboton@gmail.com> <20080102084002.GA13636@elte.hu>	 <e85b9d30801080333y3d6668ccgf20f9666d0326884@mail.gmail.com>	 <e85b9d30801080340y43fbd4c0sa9b6c9811c7391a1@mail.gmail.com>	 <47841C41.4060401@zytor.com>	 <e85b9d30801101310p485c7686o30b7cd581043712@mail.gmail.com>	 <47868B6D.6030208@zytor.com>	 <e85b9d30801101352hf66826eqe436e61310c96f14@mail.gmail.com>	 <478694CB.4000306@zytor.com> <e85b9d30801101428s1c760cb1i5ee415738dffb90f@mail.gmail.com>
In-Reply-To: <e85b9d30801101428s1c760cb1i5ee415738dffb90f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew wrote:
>> That's fine, but that was collected with the vmlinux image you sent me,
>> right?
>>
> 
> no, but now it is:
> http://kerneloftruth.neucode.org/other/crash_ia32_64/not_tainted/latest/
> (the other one was taken before I added/selected the demanded features)
> 
> what puzzles me is that it doesn't say "tainted" (not tainted) in the
> upper part & "tainted" in the lower part
> I apologize for the bad quality of the pictures ...
> 
> luckily there was also an additional call trace this time (syslog-ng
> Tainted: G   D) (don't know what it means), nvidia-module wasn't
> loaded and no other additional proprietary modules were loaded AFAIK
> 

I just managed to reproduce the bug in simulation.  I believe we should 
be able to resolve this.

	-hpa
