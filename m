Return-Path: <linux-kernel-owner+w=401wt.eu-S1753808AbYI2Ufq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbYI2Ufq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 16:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbYI2Ufi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 16:35:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59697 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbYI2Ufi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 16:35:38 -0400
Message-ID: <48E13B22.506@zytor.com>
Date: Mon, 29 Sep 2008 13:31:30 -0700
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
References: <1222472815.29886.43.camel@alok-dev1>	 <48E090B6.2080809@redhat.com> <1222710924.30247.21.camel@alok-dev1>	 <48E1227B.9040809@redhat.com> <1222717085.30247.44.camel@alok-dev1>
In-Reply-To: <1222717085.30247.44.camel@alok-dev1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> 
> How does that matter, if we are able to standardize all this then,
> hypervisors which want to run a Linux guest should effectively play by
> the standards over here or else they would never work properly on Linux.
> What we are trying to do here is try to standardize things for Linux so
> that the Linux kernel implementation for Virtualization is that much
> more easier. If this goes well other closed source hypervisors too can
> effectively follow these standards. 
> If the other closed source hypervisors define their own cpuid leafs they
> will still have to make Linux kernel side changes to make use of these
> new leafs. Which allows them to add to these pool of cpuid interface's
> too.
> 

I don't think this is a realistic point of view, especically given who 
we're dealing with in the closed-source world.

Without any kind of tagging of the information, it's realistically futile.

Intel/AMD haven't helped any by reserving a space which is entirely too 
small.

	-hpa
