Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbYI0Age@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbYI0Age (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 20:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbYI0Ag1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 20:36:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35795 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbYI0Ag0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 20:36:26 -0400
Message-ID: <48DD7F1A.4060703@zytor.com>
Date: Fri, 26 Sep 2008 17:32:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Zach Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>,
       "Jun.Nakajima@Intel.Com" <Jun.Nakajima@Intel.Com>
Subject: Re: Use CPUID to communicate with the hypervisor.
References: <1222472815.29886.43.camel@alok-dev1>	 <48DD799C.3070706@zytor.com> <1222475403.29886.57.camel@alok-dev1>
In-Reply-To: <1222475403.29886.57.camel@alok-dev1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
>>>
>> This is great, obviously... although we'll have to deal with legacy
>> methods for a while if not indefinitely (just as we have to for
>> pre-CPUID processors).
> 
> Ok, do you think we should keep those (legacy) interfaces separate so
> that they can be phased out whenever the time is right. 
> 

I don't, realistically, think we can phase them out for a very long 
time, and then it's usually a "why bother".  What we want to do is 
abstract them so they don't make the rest of the code suck.

> 
> I would like to see this as a generic hypervisor way to get frequency
> rather than a VMware specific thingy. 
>> In order for *that* to be safe, you'd have to have well-defined ranges
>> for different virtualization vendors where each of them can define their
>> own stuff.
> 
> My motivation for doing this is to have a standard across all the
> hypervisor's. If all the different hypervisor guys can come to some
> sought of consensus on the various hypervisor leafs that would help keep
> this simple and a lot more maintainable.
> 

Agreed.  However, that's obviously beyond our immediate control.

	-hpa
