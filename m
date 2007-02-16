Return-Path: <linux-kernel-owner+w=401wt.eu-S1946072AbXBPTHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946072AbXBPTHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 14:07:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946221AbXBPTHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 14:07:05 -0500
Received: from gw.goop.org ([64.81.55.164]:56516 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946072AbXBPTHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 14:07:01 -0500
Message-ID: <45D600D0.9070602@goop.org>
Date: Fri, 16 Feb 2007 11:06:56 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] killing the NR_IRQS arrays.
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>	<45D5F2EC.5000402@goop.org> <m1ps8ac4fc.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1ps8ac4fc.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Well you shouldn't need to wait just run with a kernel with NR_IRQS >= 1024.
> 1024 is stretch but it isn't to bad.  There are already x86 boxes that have
> more pins on their ioapics then that. So x86_64 and with this latest
> round of patches from Len Brown and I i386 should be able to support that.
>   

Early Xen patches did just that, but there was general criticism about
the memory use.  And in the paravirt_ops world, a large compile-time
static allocation is not really acceptable if its only needed by Xen. 
But, hey, if you're OK with it I'll submit the patch ;)

> On the other side 1024 looks extremely limiting for exposing pci devices.  
> If someone gets serious about pushing what is legal with MSI-X you may be
> in trouble.  As a single device is allowed to have 4096 interrupts.   Not
> that I can think of a user for so many but...
>   

No, I think we'll burn that bridge when we come to it.

    J
