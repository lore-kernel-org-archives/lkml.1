Return-Path: <linux-kernel-owner+w=401wt.eu-S933461AbYEVAyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461AbYEVAyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 20:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbYEVAyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 20:54:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbYEVAyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 20:54:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
       mingo@elte.hu, tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, drepper@redhat.com, Hongjiu.lu@intel.com,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       rmk+lkml@arm.linux.org.uk, dan@debian.org, asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
In-Reply-To: H. Peter Anvin's message of  Wednesday, 21 May 2008 17:28:41 -0700 <4834BE39.2000904@zytor.com>
References: <20080513011030.GA31448@linux-os.sc.intel.com>
	<18477.35703.679574.760417@harpo.it.uu.se>
	<20080518013416.GB30034@linux-os.sc.intel.com>
	<18481.37905.297556.288317@harpo.it.uu.se>
	<20080520015723.GD30034@linux-os.sc.intel.com>
	<4832A173.6020203@firstfloor.org>
	<18482.53246.642835.894623@harpo.it.uu.se>
	<4832E705.2010900@zytor.com>
	<18482.60491.764019.292031@harpo.it.uu.se>
	<20080520175325.GE30034@linux-os.sc.intel.com>
	<4834BE39.2000904@zytor.com>
Emacs: it's not slow --- it's stately.
Message-Id: <20080522005345.B994F26FA24@magilla.localdomain>
Date: Wed, 21 May 2008 17:53:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The biggest potential problem with this that I see is that relying on 
> CPUID can mess with certain virtualization solutions.  Another option to 
> accomplish the same thing would be to have a system call (preferrably a 
> prctl, since it is at least in theory personality-dependent) to query 
> what information is included in the fpstate data - since it will always 
> be the same for any particular kernel.

It's easy and cheap to add an indicator to the vDSO for this.


Thanks,
Roland
