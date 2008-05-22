Return-Path: <linux-kernel-owner+w=401wt.eu-S1765905AbYEVH0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765905AbYEVH0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 03:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758545AbYEVH0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 03:26:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58323 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758284AbYEVH03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 03:26:29 -0400
Message-ID: <48351E49.8000707@zytor.com>
Date: Thu, 22 May 2008 00:18:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
       Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
       mingo@elte.hu, tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, drepper@redhat.com, Hongjiu.lu@intel.com,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       rmk+lkml@arm.linux.org.uk, dan@debian.org, asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
References: <20080513011030.GA31448@linux-os.sc.intel.com>	<18477.35703.679574.760417@harpo.it.uu.se>	<20080518013416.GB30034@linux-os.sc.intel.com>	<18481.37905.297556.288317@harpo.it.uu.se>	<20080520015723.GD30034@linux-os.sc.intel.com>	<4832A173.6020203@firstfloor.org>	<18482.53246.642835.894623@harpo.it.uu.se>	<4832E705.2010900@zytor.com>	<18482.60491.764019.292031@harpo.it.uu.se>	<20080520175325.GE30034@linux-os.sc.intel.com>	<4834BE39.2000904@zytor.com>	<20080522005345.B994F26FA24@magilla.localdomain>	<4834CE97.9080708@zytor.com> <20080522064027.07B6B26FA24@magilla.localdomain>
In-Reply-To: <20080522064027.07B6B26FA24@magilla.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
>> Yes, but I suspect for legacy apps running without vDSO might matter.
> 
> "Legacy" apps want to be changed to make a new kind of kernel query
> and care about new details of signal frame layout for new features
> they never used before, but don't want to handle the vDSO?

I'm talking mostly about semi-embedded ISVs that have managed to get 
themselves funny ideas about what they don't want to change.  The vDSO 
definitely involves more machinery to get to.

	-hpa
