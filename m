Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbYJASUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbYJASUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 14:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbYJAST4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 14:19:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51765 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbYJASTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 14:19:55 -0400
Message-ID: <48E3BE65.2050909@zytor.com>
Date: Wed, 01 Oct 2008 11:16:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: akataria@vmware.com, "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Nakajima, Jun" <jun.nakajima@intel.com>, Dan Hecht <dhecht@vmware.com>,
       Zachary Amsden <zach@vmware.com>,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [RFC] CPUID usage for interaction between Hypervisors and Linux.
References: <1222881242.9381.17.camel@alok-dev1> <48E3BBC1.2050607@goop.org> <48E3BC47.60900@zytor.com> <48E3BD83.2090801@goop.org>
In-Reply-To: <48E3BD83.2090801@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>>
>> I suspect we can get a larger number space if we ask Intel & AMD.  In 
>> fact, I think we should request that the entire 0x40xxxxxx numberspace 
>> is assigned to virtualization *anyway*.
> 
> Yes, that would be good.  In that case I'd revise my proposal to back 
> each leaf block 256 leaves instead of 16.  But it still needs to be a 
> proper enumeration with signatures, rather than assigning fixed points 
> in that space to specific interfaces.
> 

With a sufficiently large block, we could use fixed points, e.g. by 
having each vendor create interfaces in the 0x40SSSSXX range, where SSSS 
is the PCI ID they use for PCI devices.

Note that I said "create interfaces".  It's important that all about 
this is who specified the interface -- for "what hypervisor is this" 
just use 0x40000000 and disambiguate based on that.

	-hpa
