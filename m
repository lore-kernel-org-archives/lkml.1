Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbYJAVbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbYJAVbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 17:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbYJAVa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 17:30:57 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:30277 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbYJAVa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 17:30:56 -0400
Message-ID: <48E3EBCC.70502@codemonkey.ws>
Date: Wed, 01 Oct 2008 16:29:48 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Jeremy Fitzhardinge <jeremy@goop.org>, "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Daniel Hecht <dhecht@vmware.com>, Zach Amsden <zach@vmware.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC] CPUID usage for interaction between Hypervisors and Linux.
References: <1222881242.9381.17.camel@alok-dev1> <48E3BBC1.2050607@goop.org>	 <1222894878.9381.63.camel@alok-dev1>  <48E3E6DF.8060400@codemonkey.ws> <1222896215.9381.79.camel@alok-dev1>
In-Reply-To: <1222896215.9381.79.camel@alok-dev1>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> Your explanation below answers the question you raised, the problem
> being we need to have support for each of these different hypercall
> mechanisms in the kernel. 
> I understand that this was the correct thing to do at that moment. 
> But do we want to go the same way again for CPUID when we can make it
> generic (flat enough) for anybody to use it in the same manner and
> expose a generic interface to the kernel.
>   

But what sort of information can be stored in cpuid that's actually 
useful?  Right now we just it in KVM for feature bits.  Most of the 
stuff that's interesting is stored in shared memory because a guest can 
read that without taking a vmexit or via a hypercall.

We can all agree upon a common mechanism for doing something but if no 
one is using that mechanism to do anything significant, what purpose 
does it serve?

Regards,

Anthony Liguori

