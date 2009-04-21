Return-Path: <linux-kernel-owner+w=401wt.eu-S1758221AbZDUVQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221AbZDUVQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 17:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbZDUVQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 17:16:11 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:25052 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbZDUVQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 17:16:10 -0400
Message-ID: <49EE3794.1070904@codemonkey.ws>
Date: Tue, 21 Apr 2009 16:16:04 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Huang Ying <ying.huang@intel.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2] Add MCE support to KVM
References: <1239953345.6842.3.camel@yhuang-dev.sh.intel.com> <49E9F7BE.4090904@codemonkey.ws> <49EAE334.9020803@redhat.com> <49EDF057.9060501@codemonkey.ws> <49EDF287.9020908@redhat.com> <49EE2497.3060009@codemonkey.ws> <49EE25CB.6070709@redhat.com> <49EE27C2.3060505@codemonkey.ws> <49EE304D.5060108@redhat.com>
In-Reply-To: <49EE304D.5060108@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>
> Example: SMP.

There was no KVM support in QEMU at the time when SMP was introduced.  
Had there been, I see no reason not to do it in upstream QEMU.

> Example: vlan API.

You'll have to be more specific.  Do you mean the up coming vlan API 
refactoring?  That absolutely should be happening in upstream QEMU.

>>> For this kind of work, we can provide kvm-userspace.git as a kind of 
>>> playground where these experiments may be made.  kvm-userspace.git 
>>> exists to support kvm.git; while qemu.git has a life of its own and 
>>> more stringent barriers to acceptance.
>>
>> As long as people are using kvm-userspace.git instead of qemu.git, 
>> we're failing IMHO.  If kvm-userspace.git is basically the equivalent 
>> of the x86 git kernel tree, linux-next, or something like that, then 
>> that's a good thing.
>
> That's definitely a long term goal, but qemu is not yet at a point 
> where it is easy to implement new features efficiently.  Once it 
> reaches that state, kvm-userspace will become a simple staging ground 
> (or even disappear entirely).

The simple fact is that right now, Fedora ships kvm-userspace and calls 
it QEMU.  It builds packages for non-KVM enabled boards.  There is a 
very large userspace that consumes packages derived from kvm-userspace.  
Like it or not, kvm-userspace is not an experimental staging ground for 
QEMU.

The only reasonable things to do IMHO is for as much as humanly possible 
to be deferred to QEMU or for you to comes to terms with your role as a 
defacto QEMU maintainer and start pushing back more on patch sets that 
don't take into consideration TCG/non-KVM environments :-)

MCE is a perfect example of something that really has no reason to go in 
via kvm-userspace since we have enough KVM support in upstream QEMU.

Regards,

Anthony Liguori
