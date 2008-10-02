Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbYJBLwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbYJBLwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 07:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbYJBLwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 07:52:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46983 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227AbYJBLwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 07:52:37 -0400
Message-ID: <48E4B5E8.60400@redhat.com>
Date: Thu, 02 Oct 2008 14:52:08 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Gerd Hoffmann <kraxel@redhat.com>, Alok Kataria <akataria@vmware.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Daniel Hecht <dhecht@vmware.com>,
       "Jun.Nakajima@Intel.Com" <Jun.Nakajima@Intel.Com>
Subject: Re: Use CPUID to communicate with the hypervisor.
References: <1222472815.29886.43.camel@alok-dev1>	 <48E090B6.2080809@redhat.com> <1222710924.30247.21.camel@alok-dev1>	 <48E1227B.9040809@redhat.com> <1222717085.30247.44.camel@alok-dev1>	 <48E15AC7.2080603@redhat.com> <1222734838.30247.102.camel@alok-dev1>	 <48E1DF2C.9050409@redhat.com> <1222792958.7330.16.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1222792958.7330.16.camel@bodhitayantram.eng.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
>> Well, that should be clearly defined, that is my point.  When asking the
>> hypervisor for the tsc instead of running a calibration loop, then we
>> have a small bit of paravirtualization:  The guest is aware that it runs
>> on a hypervisor and just asks it directly.  So while we are at it we can
>> also define a way to communicate tsc freq changes between host and
>> guest, so the cost of trap'n'emulate tsc reads can be avoided.  Or we
>> define "tsc is constant" and leave it to the hypervisor to make sure it
>>     
>
> For our purposes, we define TSC is constant.
>   

I believe VMware doesn't actually change cpu frequency dynamically.  But 
what about hypervisors that do?  and what about large machines, which do 
not actually have a constant tsc?

You are defining something as constant which in fact is not constant.

-- 
error compiling committee.c: too many arguments to function

