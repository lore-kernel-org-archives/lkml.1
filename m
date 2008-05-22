Return-Path: <linux-kernel-owner+w=401wt.eu-S935364AbYEVIv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935364AbYEVIv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 04:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935325AbYEVIuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 04:50:50 -0400
Received: from aun.it.uu.se ([130.238.12.36]:36653 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934287AbYEVIus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 04:50:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18485.13215.945.950687@harpo.it.uu.se>
Date: Thu, 22 May 2008 10:49:34 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Roland McGrath <roland@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
       mingo@elte.hu, tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, drepper@redhat.com, Hongjiu.lu@intel.com,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       rmk+lkml@arm.linux.org.uk, dan@debian.org, asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
In-Reply-To: <20080522005345.B994F26FA24@magilla.localdomain>
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
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath writes:
 > > The biggest potential problem with this that I see is that relying on 
 > > CPUID can mess with certain virtualization solutions.  Another option to 
 > > accomplish the same thing would be to have a system call (preferrably a 
 > > prctl, since it is at least in theory personality-dependent) to query 
 > > what information is included in the fpstate data - since it will always 
 > > be the same for any particular kernel.
 > 
 > It's easy and cheap to add an indicator to the vDSO for this.

For our user-space virtualisation code a plain system call,
like prctl(), would be strongly preferable. Right now I
can't say whether a vDSO solution would work at all for us,
but a system call solution would be no problem at all.

/Mikael
