Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576Ab0BDFSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 00:18:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab0BDFSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 00:18:30 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "Lu, Hongjiu" <hongjiu.lu@intel.com>
X-Fcc: ~/Mail/linus
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Lachner, Peter" <peter.lachner@intel.com>
Subject: RE: [patch] x86: ptrace and core-dump extensions for xstate
In-Reply-To: Lu, Hongjiu's message of  Wednesday, 3 February 2010 21:01:32 -0800 <8EA2C2C4116BF44AB370468FBF85A7770123AAB3A1@orsmsx504.amr.corp.intel.com>
References: <1265076025.2802.194.camel@sbs-t61.sc.intel.com>
	<20100203230817.E6529AA@magilla.sf.frob.com>
	<8EA2C2C4116BF44AB370468FBF85A7770123AAB0AE@orsmsx504.amr.corp.intel.com>
	<20100204020224.45379725@magilla.sf.frob.com>
	<8EA2C2C4116BF44AB370468FBF85A7770123AAB2E8@orsmsx504.amr.corp.intel.com>
	<20100204021659.AB348C880@magilla.sf.frob.com>
	<8EA2C2C4116BF44AB370468FBF85A7770123AAB303@orsmsx504.amr.corp.intel.com>
	<20100204045458.5AA2F7290@magilla.sf.frob.com>
	<8EA2C2C4116BF44AB370468FBF85A7770123AAB3A1@orsmsx504.amr.corp.intel.com>
Emacs: where editing text is like playing Paganini on a glass harmonica.
Message-Id: <20100204051816.E8F68815A@magilla.sf.frob.com>
Date: Wed,  3 Feb 2010 21:18:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Suresh's patch puts this value in the xsave block, in what Suresh calls
> > "sw_usable_bytes".  See the asm/ptrace-abi.h comment in the patch you
> > signed off on.
> >
> > How is that not sufficient?  If it is indeed not sufficient to usefully
> > interpret the xsave block, then how could an xsave block in a core dump
> > file ever possibly be examined if it might not have been generated on the
> > same system and kernel where the debugger is doing the examination?  If
> > the NT_X86_XSTATE note as implemented in Suresh's patch is indeed not
> > entirely self-contained in this way, then NAK on that new note format.
> > 
> 
> I use it when reading core dump, which doesn't involve a system call.
> I can analyze it on a totally different machine.

You did not answer any of my questions.
Perhaps Suresh can be more helpful in explaining the situation.


Thanks,
Roland
