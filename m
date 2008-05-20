Return-Path: <linux-kernel-owner+w=401wt.eu-S1764028AbYETSB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764028AbYETSB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755869AbYETSBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:01:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35709 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943AbYETSBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:01:50 -0400
Message-ID: <483310F0.5030902@zytor.com>
Date: Tue, 20 May 2008 10:57:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: Andi Kleen <andi@firstfloor.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, roland@redhat.com, drepper@redhat.com,
       Hongjiu.lu@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, rmk+lkml@arm.linux.org.uk, dan@debian.org,
       asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
References: <20080513011030.GA31448@linux-os.sc.intel.com>	<18477.35703.679574.760417@harpo.it.uu.se>	<20080518013416.GB30034@linux-os.sc.intel.com>	<18481.37905.297556.288317@harpo.it.uu.se>	<20080520015723.GD30034@linux-os.sc.intel.com>	<4832A173.6020203@firstfloor.org>	<18482.53246.642835.894623@harpo.it.uu.se>	<4832E705.2010900@zytor.com> <18482.60491.764019.292031@harpo.it.uu.se>
In-Reply-To: <18482.60491.764019.292031@harpo.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> 
> An ugly workaround could be to start clearing one of these fields,
> and say that the data there is only valid for kernels >= 2.6.26.
> (I said it was ugly...)
> 
> Or we go back to stashing a flag in uc_flags (which is kosher),
> and try to figure out how to mark non-rt sigframes.
> 

Or use the OSXSAVE hack.  Let me think about this for some time.

There is also the option of simply using a field guarded by a 64- or 
128-bit magic number.  It's a bit ugly, but it works.

	-hpa
