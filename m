Return-Path: <linux-kernel-owner+w=401wt.eu-S933494AbYETPAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933494AbYETPAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933268AbYETPAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:00:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45127 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933262AbYETPAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:00:14 -0400
Message-ID: <4832E672.3090702@zytor.com>
Date: Tue, 20 May 2008 07:55:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
       Mikael Pettersson <mikpe@it.uu.se>, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       roland@redhat.com, drepper@redhat.com, Hongjiu.lu@intel.com,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       rmk+lkml@arm.linux.org.uk, dan@debian.org, asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
References: <20080513011030.GA31448@linux-os.sc.intel.com> <18477.35703.679574.760417@harpo.it.uu.se> <20080518013416.GB30034@linux-os.sc.intel.com> <18481.37905.297556.288317@harpo.it.uu.se> <20080520015723.GD30034@linux-os.sc.intel.com> <4832A173.6020203@firstfloor.org>
In-Reply-To: <4832A173.6020203@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Ok. CPU folks are planning to make some of the bytes at the end of fxsave
>> image, SW usable.
> 
> Are they always zeroed in earlier CPUs though?  If not that wouldn't
> work 100% reliably because whatever cookie you put in could have been
> there before by chance.
> 
> I don't see anything in the SDM guaranteeing zeroing.
> 

I'm pretty sure they weren't zeroed by the CPUs.  If they weren't zeroed 
*by the kernel*, there might have been an information leak.

	-hpa
