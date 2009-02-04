Return-Path: <linux-kernel-owner+w=401wt.eu-S1756380AbZBDRXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380AbZBDRXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 12:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZBDRXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 12:23:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51449 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbZBDRXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 12:23:15 -0500
Message-ID: <4989CEC6.5040502@redhat.com>
Date: Wed, 04 Feb 2009 19:22:14 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL -tip v3] fix 39 'make headers_check' warnings
References: <1232287474.3130.19.camel@localhost.localdomain> <4989B6F7.4060004@redhat.com> <1233763212.3523.5.camel@localhost.localdomain> <200902041737.57453.arnd@arndb.de>
In-Reply-To: <200902041737.57453.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Wednesday 04 February 2009, Jaswinder Singh Rajput wrote:
>   
>> On Wed, 2009-02-04 at 17:40 +0200, Avi Kivity wrote:
>>     
>>> If there's such a patch in the URL you posted, please point to it directly.
>>>
>>>       
>> All CONFIG_* patches are dropped.
>>     
>
> Well, the kvm.h patch was one of two that AFAICT are actually needed:
> If you don't define CONFIG_X86 or CONFIG_IA64 in user space, you
> won't see the definitions for kvm_irqchip->pic, kvm_irqchip->ioapic
> or KVM_CAP_{DEVICE_ASSIGNMENT,DEVICE_MSI,USER_MSI}.
>   

I have a fix for that queued.


-- 
error compiling committee.c: too many arguments to function

