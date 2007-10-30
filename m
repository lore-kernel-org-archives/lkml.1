Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbXJ3Jkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbXJ3Jkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbXJ3Jkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:40:45 -0400
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:43156 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751351AbXJ3Jko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:40:44 -0400
X-Greylist: delayed 1800 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Oct 2007 05:40:43 EDT
Date: Tue, 30 Oct 2007 10:10:40 +0100
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: Re: 2.6.24-rc1-82798a1 compile failure (x86_64)
In-reply-to: <alpine.LFD.0.9999.0710300033470.3186@localhost.localdomain>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Message-id: <4726F510.9060207@archlinux.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 8BIT
X-IronPort-AV: E=Sophos;i="4.21,346,1188770400";   d="scan'208";a="31803413"
X-Enigmail-Version: 0.95.1
References: <fg5kar$d70$1@ger.gmane.org>
 <alpine.LFD.0.9999.0710292310040.3186@localhost.localdomain>
 <47266BF6.6070206@archlinux.org>
 <alpine.LFD.0.9999.0710300033470.3186@localhost.localdomain>
User-Agent: Thunderbird 2.0.0.6 (X11/20071015)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner schrieb:
> On Tue, 30 Oct 2007, Thomas Bächler wrote:
> 
>> Thomas Gleixner schrieb:
>>> Thomas,
>>>
>>> On Mon, 29 Oct 2007, Thomas Bächler wrote:
>>>> x86_64 fails to compile for me with this error:
>>>>
>>>>   CC      arch/x86/kernel/vsyscall_64.o
>>>> {standard input}: Assembler messages:
>>>> {standard input}:434: Error: symbol `vsysc2' is already defined
>>>> make[1]: *** [arch/x86/kernel/vsyscall_64.o] Error 1
>>>> make: *** [arch/x86/kernel] Error 2
>>>>
>>>> The .config is attached. What's wrong?
>>> Very recent gcc I guess ? Patch below should fix this.
>> Indeed very recent. The patch doesn't solve the problem though:
>>   CC      arch/x86/kernel/vsyscall_64.o
>> {standard input}: Assembler messages:
>> {standard input}:436: Error: symbol `vsysc2' is already defined
>> make[1]: *** [arch/x86/kernel/vsyscall_64.o] Error 1
>> make: *** [arch/x86/kernel] Error 2
>>
>> gcc (GCC) 4.2.2
>> GNU assembler (GNU Binutils) 2.18
> 
> Doh, no idea right now. Ingo has a 4.2.2 toolchain handy and will
> check tomorrow.
> 
> Thanks,
> 
> 	tglx

I just remembered, a friend of mine got it to compile with the exact
same toolchain, but with a different configuration (which I don't have).
He used a snapshot tarball from yesterday though, not the git tree.
