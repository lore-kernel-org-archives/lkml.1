Return-Path: <linux-kernel-owner+w=401wt.eu-S932543AbYETULa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543AbYETULa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 16:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758693AbYETULW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 16:11:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757297AbYETULU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 16:11:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
X-Fcc: ~/Mail/linus
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Mikael Pettersson <mikpe@it.uu.se>, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       drepper@redhat.com, Hongjiu.lu@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, rmk+lkml@arm.linux.org.uk, dan@debian.org,
       asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
In-Reply-To: Andi Kleen's message of  Tuesday, 20 May 2008 17:03:55 +0200 <4832E85B.4080303@firstfloor.org>
References: <20080513011030.GA31448@linux-os.sc.intel.com>
	<18477.35703.679574.760417@harpo.it.uu.se>
	<20080518013416.GB30034@linux-os.sc.intel.com>
	<18481.37905.297556.288317@harpo.it.uu.se>
	<20080520015723.GD30034@linux-os.sc.intel.com>
	<4832A173.6020203@firstfloor.org>
	<4832E672.3090702@zytor.com>
	<4832E85B.4080303@firstfloor.org>
Emacs: the prosecution rests its case.
Message-Id: <20080520201044.ED62B26FA1C@magilla.localdomain>
Date: Tue, 20 May 2008 13:10:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't think there is one. We never copy fxsave completely out of the
> kernel. x86-64 does FXSAVE directly in/out user space, but the
> only leak is what there was before.

ptrace/user_regset copies out and in the whole fxsave block from the ptrace
caller.  (Only the mxcsr word is constrained after copy-in.)


Thanks,
Roland
