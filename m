Return-Path: <linux-kernel-owner+w=401wt.eu-S1752556AbYI1FBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbYI1FBR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 01:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbYI1FBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 01:01:04 -0400
Received: from gw.goop.org ([64.81.55.164]:41846 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbYI1FBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 01:01:03 -0400
Message-ID: <48DF0F8D.3070302@goop.org>
Date: Sat, 27 Sep 2008 22:01:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Zach Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>,
       "Jun.Nakajima@Intel.Com" <Jun.Nakajima@Intel.Com>,
       Tim Deegan <Tim.Deegan@citrix.com>
Subject: Re: Use CPUID to communicate with the hypervisor.
References: <1222472815.29886.43.camel@alok-dev1>  <48DD860C.50809@goop.org> <1222485079.23825.13.camel@alok-dev1>
In-Reply-To: <1222485079.23825.13.camel@alok-dev1>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
>> I think there's a move towards doing a scan for a signature, such as
>> checking every 16 leaves after 0x40000000 for "a while" looking for
>> interesting signatures, so that a hypervisor can support multiple ABIs
>> at once.  Given this, it would be better to define a "Generic Hypervisor
>> ABI" signature, and put all the related leaves together.
>>     
>
> Hmm interesting, do you have any pointers to this ?
>   

No.  I think I saw a passing reference from Tim Deegan to it, but I
couldn't find it again when I looked.

> As far as live migration, for full-virt, we think that it should happen
> invisibly to the guest.  So even if we move to a host with different TSC
> frequency it should be the job of the hypervisor to still emulate the
> old frequency. 
>   

Can the tsc be emulated without a performance hit, or does it trap into
the hypervisor?

    J
