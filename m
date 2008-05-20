Return-Path: <linux-kernel-owner+w=401wt.eu-S933930AbYETSOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933930AbYETSOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932159AbYETSHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:07:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57785 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762644AbYETSHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:07:13 -0400
Message-ID: <4833118D.5050001@zytor.com>
Date: Tue, 20 May 2008 10:59:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
       mingo@elte.hu, tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, roland@redhat.com, drepper@redhat.com,
       Hongjiu.lu@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, rmk+lkml@arm.linux.org.uk, dan@debian.org,
       asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
References: <20080513011030.GA31448@linux-os.sc.intel.com> <18477.35703.679574.760417@harpo.it.uu.se> <20080518013416.GB30034@linux-os.sc.intel.com> <18481.37905.297556.288317@harpo.it.uu.se> <20080520015723.GD30034@linux-os.sc.intel.com> <4832A173.6020203@firstfloor.org> <18482.53246.642835.894623@harpo.it.uu.se> <4832E705.2010900@zytor.com> <18482.60491.764019.292031@harpo.it.uu.se> <20080520175325.GE30034@linux-os.sc.intel.com>
In-Reply-To: <20080520175325.GE30034@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> 
> This issue of not-zeroing, is present in only 64bit kernels and for 64bit apps,
> right?
> 
> 64bit app signal handling uses only rt_frame, so we can add an uc_flag for
> them and for 32bit apps, kernel was always zero'ing the reserved bits
> at the end of _fpstate.
> 
> In short, for non-rt frames, they can check the reserved bits at the end
> of fpstate frame and for rt-frames (perhaps even for 32bit rt frame handling)
> apps can check for uc_flag aswell, for extended state presence. Is this
> good enough?
> 

Are we sure about the "always" bit here (I suspect yes, but we may want 
to double-check at least back to 2.2 or 2.4.)

Anyway, seems reasonable enough to me.

	-hpa
