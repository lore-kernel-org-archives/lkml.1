Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbYI2SGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbYI2SGn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbYI2SDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:03:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50464 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959AbYI2SCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:52 -0400
Message-ID: <48E11751.8070901@zytor.com>
Date: Mon, 29 Sep 2008 10:58:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Gerd Hoffmann <kraxel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Zach Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>,
       "Jun.Nakajima@Intel.Com" <Jun.Nakajima@Intel.Com>
Subject: Re: Use CPUID to communicate with the hypervisor.
References: <1222472815.29886.43.camel@alok-dev1>	 <48E090B6.2080809@redhat.com> <1222710924.30247.21.camel@alok-dev1>
In-Reply-To: <1222710924.30247.21.camel@alok-dev1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
>> Shouldn't you check the hypervisor signature here?
> 
> Nope the whole idea of not checking the hypervisor signature is that we
> should keep this interface generic. 

Unfortunately, given current evidence this is entirely unrealistic.

> So for instance right now, VMware has defined 40000010 leaf, if either
> kvm/xen think it could be useful they could just define that leaf to
> return nonzero value and the kernel will start using it for them.
> Likewise, if in future either kvm/xen come up with a need to define a
> new CPUID leaf they can define the semantics for that leaf, and the
> corresponding kernel side stuff. If VMware, think that this new leaf is
> useful, we can then support that leaf in our hypervisor or return zero
> otherwise.

This is only true if you can also except M$ and other hypervisor vendors 
to stick to it.  So far, hypervisor vendors have hardly shown any 
inclination toward standardization.

Hence I really don't think it is sane.

	-hpa
