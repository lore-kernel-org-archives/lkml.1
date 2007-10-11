Return-Path: <linux-kernel-owner+w=401wt.eu-S1759345AbXJKWBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345AbXJKWBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 18:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754789AbXJKWBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 18:01:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:56541 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755095AbXJKWBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 18:01:33 -0400
In-Reply-To: <18190.39864.4562.852292@cargo.ozlabs.ibm.com>
References: <20071011071558.676463639@au1.ibm.com> <20071011072208.075979098@au1.ibm.com> <DFC6881D-E917-4EC5-B19C-8CE04E040B06@kernel.crashing.org> <18190.39864.4562.852292@cargo.ozlabs.ibm.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <2C31F1C3-3337-483B-A463-767459305F1E@kernel.crashing.org>
Cc: markn@au1.ibm.com, PowerPC dev list <linuxppc-dev@ozlabs.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [patch 1/2] Replace NT_PRXFPREG with ELF_CORE_XFPREG_TYPE #define
Date: Thu, 11 Oct 2007 17:01:43 -0500
To: Paul Mackerras <paulus@samba.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 11, 2007, at 4:55 PM, Paul Mackerras wrote:

> Kumar Gala writes:
>
>>> #define ELF_CORE_XFPREG_TYPE to be NT_PRXFPREG in all current  
>>> users so
>>> there's are no change in behaviour.
>>
>> Can we make this ELF_CORE_VECREG_TYPE or something that is so coupled
>> to the x86 specific name?
>
> How is "extended floating point registers" x86-specific?

we'll I don't consider the altivec register file as 'extended fp'.   
I'm assuming the name XFP came from IA32 land when MMX/SSE came into  
existence.

> ELF_CORE_XFPREG_TYPE is a suitable name for something that's used in
> conjunction with a function called elf_core_copy_task_xfpregs().

agreed, I think the function name should change as well.

- k
