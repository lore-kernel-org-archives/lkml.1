Return-Path: <linux-kernel-owner+w=401wt.eu-S1763697AbYEVGkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763697AbYEVGkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 02:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbYEVGkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 02:40:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755950AbYEVGkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 02:40:40 -0400
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
In-Reply-To: H. Peter Anvin's message of  Wednesday, 21 May 2008 18:38:31 -0700 <4834CE97.9080708@zytor.com>
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
	<20080522005345.B994F26FA24@magilla.localdomain>
	<4834CE97.9080708@zytor.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080522064027.07B6B26FA24@magilla.localdomain>
Date: Wed, 21 May 2008 23:40:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, but I suspect for legacy apps running without vDSO might matter.

"Legacy" apps want to be changed to make a new kind of kernel query
and care about new details of signal frame layout for new features
they never used before, but don't want to handle the vDSO?


Thanks,
Roland
