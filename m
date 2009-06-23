Return-Path: <linux-kernel-owner+w=401wt.eu-S1754362AbZFWKXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbZFWKXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 06:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbZFWKXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 06:23:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49748 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbZFWKXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 06:23:04 -0400
Message-ID: <4A40AD3A.5000008@redhat.com>
Date: Tue, 23 Jun 2009 13:23:54 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       =?ISO-8859-1?Q?Christian_Borntr=E4ger?= <borntrae@de.ibm.com>
Subject: Re: linux-next: kvm tree build failure
References: <20090623155345.11219074.sfr@canb.auug.org.au>
In-Reply-To: <20090623155345.11219074.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2009 08:53 AM, Stephen Rothwell wrote:
> Hi Avi,
>
> Today's linux-next build (s390 allmodconfig) failed like this:
>
> In file included from include/trace/ftrace.h:261,
>                   from include/trace/define_trace.h:56,
>                   from include/trace/events/kvm.h:55,
>                   from arch/s390/kvm/../../../virt/kvm/kvm_main.c:63:
> include/trace/events/kvm.h: In function 'ftrace_raw_output_kvm_ack_irq':
> include/trace/events/kvm.h:31: error: 'KVM_IRQCHIP_PIC_MASTER' undeclared (first use in this function)
> include/trace/events/kvm.h:31: error: (Each undeclared identifier is reported only once
> include/trace/events/kvm.h:31: error: for each function it appears in.)
> include/trace/events/kvm.h:31: error: 'KVM_IRQCHIP_PIC_SLAVE' undeclared (first use in this function)
> include/trace/events/kvm.h:31: error: 'KVM_IRQCHIP_IOAPIC' undeclared (first use in this function)
>
> Caused by commit acb57be20f6b600848a99796d8f115ec079b8b08 ("KVM: convert
> custom marker based tracing to event traces").
>
>    

I applied a patch from Christian Borntraeger addressing this.

-- 
error compiling committee.c: too many arguments to function

