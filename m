Return-Path: <linux-kernel-owner+w=401wt.eu-S1758703AbZCAXiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703AbZCAXiu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 18:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756557AbZCAXil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 18:38:41 -0500
Received: from gw.goop.org ([64.81.55.164]:36131 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756351AbZCAXil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 18:38:41 -0500
Message-ID: <49AB1C7D.2040605@goop.org>
Date: Sun, 01 Mar 2009 15:38:37 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jody Belka <lists-xen@pimb.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] xen: core dom0 support
References: <1235786365-17744-1-git-send-email-jeremy@goop.org>	<20090227212812.26d02f34.akpm@linux-foundation.org>	<49A8DF28.4050301@goop.org>	<200902282309.07576.nickpiggin@yahoo.com.au>	<20090228181115.GU2056@pimb.org> <871vti2zsl.fsf@basil.nowhere.org>
In-Reply-To: <871vti2zsl.fsf@basil.nowhere.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Jody Belka <lists-xen@pimb.org> writes:
>   
>> Is it duplication though? I personally have machines with older processors
>> that don't have hvm support. I plan on keeping these around for a good amount
>> of time, and would love to be running them on mainline. So for me, unless KVM
>> is somehow going to support para-virtualisation, this isn't duplication.
>>     
>
> The old systems will continue to run fine with a 2.6.18 Dom0 though.

But that suggests the *only* reason to update kernels is to get new 
hardware support.  Or conversely, we should stop trying to be backwards 
compatible with old hardware in new kernels because there's no reason to 
keep it.

While a lot of the delta between 2.6.18 has been hardware support 
updates, there have been a lot of other useful things: a new CPU 
scheduler, tickless operation (which directly important for 
virtualization), all the cgroups stuff, new filesystems, IO schedulers, 
etc, etc.  All good things to have, even on older hardware.

    J
