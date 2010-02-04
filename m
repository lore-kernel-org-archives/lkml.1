Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab0BDCCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 21:02:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087Ab0BDCCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 21:02:38 -0500
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
In-Reply-To: Lu, Hongjiu's message of  Wednesday, 3 February 2010 15:45:12 -0800 <8EA2C2C4116BF44AB370468FBF85A7770123AAB0AE@orsmsx504.amr.corp.intel.com>
References: <1265076025.2802.194.camel@sbs-t61.sc.intel.com>
	<20100203230817.E6529AA@magilla.sf.frob.com>
	<8EA2C2C4116BF44AB370468FBF85A7770123AAB0AE@orsmsx504.amr.corp.intel.com>
X-Shopping-List: (1) Extemporaneous rectum animals
   (2) Impotent advantageous cheater-hawks
   (3) Jellied travesty
Message-Id: <20100204020224.45379725@magilla.sf.frob.com>
Date: Wed,  3 Feb 2010 18:02:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Gdb calls cpuid during startup time to find out the actual xstate_size
> on the target machine. It has to be reliable. There is no need for
> another ptrace option. But we should document it clearly in ABI.

As I said, I think that is an extremely poor API choice.  There is no such
arcane requirement in the API now, so we do not have add one.


Thanks,
Roland
