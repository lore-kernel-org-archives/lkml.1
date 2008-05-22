Return-Path: <linux-kernel-owner+w=401wt.eu-S934035AbYEVIGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934035AbYEVIGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 04:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760988AbYEVIGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 04:06:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33683 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760617AbYEVIGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 04:06:11 -0400
Date: Thu, 22 May 2008 10:14:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Roland McGrath <roland@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Mikael Pettersson <mikpe@it.uu.se>, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       drepper@redhat.com, Hongjiu.lu@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, rmk+lkml@arm.linux.org.uk, dan@debian.org,
       asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
Message-ID: <20080522081421.GB31727@one.firstfloor.org>
References: <18477.35703.679574.760417@harpo.it.uu.se> <20080518013416.GB30034@linux-os.sc.intel.com> <18481.37905.297556.288317@harpo.it.uu.se> <20080520015723.GD30034@linux-os.sc.intel.com> <4832A173.6020203@firstfloor.org> <4832E672.3090702@zytor.com> <4832E85B.4080303@firstfloor.org> <20080520201044.ED62B26FA1C@magilla.localdomain> <4834B8DB.6030504@zytor.com> <20080522004752.C399426FA24@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522004752.C399426FA24@magilla.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> AFAIK the only reason we control the MXCSR value is because we don't
> want to handle a #GP in context switch.  

x86-64 actually handles it in context switch, just i386 doesn't.

-Andi
