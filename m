Return-Path: <linux-kernel-owner+w=401wt.eu-S1755616AbZITTCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbZITTCo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 15:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbZITTCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 15:02:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723AbZITTCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 15:02:40 -0400
Message-ID: <4AB67BB0.3020303@redhat.com>
Date: Sun, 20 Sep 2009 22:00:00 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Alok Kataria <akataria@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Paravirtualization on VMware's Platform [VMI].
References: <1253233028.19731.63.camel@ank32.eng.vmware.com>	<20090919224430.GB9567@kroah.com>	<1253419185.3253.21.camel@ank32.eng.vmware.com>	<20090920074247.GA5733@elte.hu> <20090920095239.456ad6f2@infradead.org> <4AB5EF25.9070502@redhat.com> <4AB64EFC.10707@goop.org>
In-Reply-To: <4AB64EFC.10707@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2009 06:49 PM, Jeremy Fitzhardinge wrote:
>> kvm will be removing the pvmmu support soon; and Xen is talking about
>> running paravirtualized guests in a vmx/svm container where they don't
>> need most of the hooks.
>>
>>      
> We have no plans to drop support for non-vmx/svm capable processors, let
> alone require ept/npt.
>    

Today, certainly; similarly kvm will host-side pvmmu support for a while 
to support live migration from older hosts.

But in a few years it may make sense to run everything in a vmx/svm 
container even for Xen; we can then drop x86 pv_ops for good.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

