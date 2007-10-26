Return-Path: <linux-kernel-owner+w=401wt.eu-S1765533AbXJZRFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765533AbXJZRFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbXJZRFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:05:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52947 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757761AbXJZRFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:05:34 -0400
Message-ID: <47221D2A.2050304@zytor.com>
Date: Fri, 26 Oct 2007 10:00:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "Huang, Ying" <ying.huang@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/3 -v4] x86_64 EFI runtime service support: EFI basic
 runtime service support
References: <1193295473.23935.202.camel@caritas-dev.intel.com>	<alpine.LFD.0.9999.0710251800250.3186@localhost.localdomain>	<1193360591.23935.212.camel@caritas-dev.intel.com> <20071026123128.4fbe9568@the-village.bc.nu>
In-Reply-To: <20071026123128.4fbe9568@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>> Again, these are wrappers to access EFI and not Windows.
>> EFI uses the Windows x86_64 calling convention. The lin2win may be a
>> more general naming convention that can be used for some other code (the
>> NDISwrapper?) in the future. Do you agree?
> 
> The SYSV description is wrong as well. SYSV has no calling convention. I
> think you mean iABI or iBCS2 ?
> 
> Whats wrong with following the pattern of other calls like syscall(...)
> and just having eficall() ?

Either that (which is basically his lin2win6), or use wrapper-generators 
like we used to do for system calls -- the latter will produce more 
efficient code.  I don't think it matters.

	-hpa
