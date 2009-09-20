Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbZITJCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbZITJCM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 05:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbZITJCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 05:02:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbZITJCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 05:02:11 -0400
Message-ID: <4AB5EF25.9070502@redhat.com>
Date: Sun, 20 Sep 2009 12:00:21 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Alok Kataria <akataria@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Paravirtualization on VMware's Platform [VMI].
References: <1253233028.19731.63.camel@ank32.eng.vmware.com>	<20090919224430.GB9567@kroah.com>	<1253419185.3253.21.camel@ank32.eng.vmware.com>	<20090920074247.GA5733@elte.hu> <20090920095239.456ad6f2@infradead.org>
In-Reply-To: <20090920095239.456ad6f2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2009 10:52 AM, Arjan van de Ven wrote:
> On Sun, 20 Sep 2009 09:42:47 +0200
> Ingo Molnar<mingo@elte.hu>  wrote:
>
>    
>> If we were able to rip out all (or most) of paravirt from arch/x86 it
>> would be tempting for other technical reasons - but the patch above
>> is well localized.
>>      
> interesting question is if this would allow us to remove a few of the
> paravirt hooks....
>    

kvm will be removing the pvmmu support soon; and Xen is talking about 
running paravirtualized guests in a vmx/svm container where they don't 
need most of the hooks.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

