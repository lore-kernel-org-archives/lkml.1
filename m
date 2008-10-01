Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbYJAVct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbYJAVct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 17:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbYJAVck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 17:32:40 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:52620 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbYJAVcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 17:32:39 -0400
Message-ID: <48E3EC32.4030603@codemonkey.ws>
Date: Wed, 01 Oct 2008 16:31:30 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: akataria@vmware.com, Jeremy Fitzhardinge <jeremy@goop.org>,
       "avi@redhat.com" <avi@redhat.com>,
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
References: <1222881242.9381.17.camel@alok-dev1> <48E3BBC1.2050607@goop.org> <1222894878.9381.63.camel@alok-dev1> <48E3E6DF.8060400@codemonkey.ws> <20081001211532.GC634@sequoia.sous-sol.org>
In-Reply-To: <20081001211532.GC634@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> * Anthony Liguori (anthony@codemonkey.ws) wrote:
>   
>> We've already gone down the road of trying to make standard paravirtual  
>> interfaces (via virtio).  No one was sufficiently interested in  
>> collaborating.  I don't see why other paravirtualizations are going to  
>> be much different.
>>     
>
> The point is to be able to support those interfaces.  Presently a Linux guest
> will test and find out which HV it's running on, and adapt.  Another
> guest will fail to enlighten itself, and perf will suffer...yadda, yadda.
>   

Agreeing on CPUID does not get us close at all to having shared 
interfaces for paravirtualization.  As I said in another note, there are 
more fundamental things that we differ on (like hypercall mechanism) 
that's going to make that challenging.

We already are sharing code, when appropriate (see the Xen/KVM PV clock 
interface).

Regards,

Anthony Liguori

> thanks,
> -chris
>   

