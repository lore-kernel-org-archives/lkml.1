Return-Path: <linux-kernel-owner+w=401wt.eu-S1751817AbZBDNzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbZBDNzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 08:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbZBDNzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 08:55:12 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55127 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbZBDNzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 08:55:11 -0500
Message-ID: <49899E34.5040404@redhat.com>
Date: Wed, 04 Feb 2009 15:55:00 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for January 23 (kvm)
References: <20090123184826.f2c91472.sfr@canb.auug.org.au> <497A29D0.2010307@oracle.com>
In-Reply-To: <497A29D0.2010307@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> Stephen Rothwell wrote:
>   
>> Hi all,
>>
>> News:  I will be on leave next week, so there will probably be no
>> linux-next release until Feb 2.
>>
>> Changes since 20090122:
>>     
>
>
> kvm changes cause this build error on i386:
>
> when kvm is built as module:
> ERROR: "__moddi3" [arch/x86/kvm/kvm.ko] undefined!
>
> or when kvm is built into the kernel image:
> lapic.c:(.text+0x19276): undefined reference to `__moddi3'
>
>
> I guess it's this line:
> 	ns = ktime_to_ns(remaining) % apic->timer.period;
>   

Now fixed.  Sorry about the delay - was on vacation.

-- 
error compiling committee.c: too many arguments to function

