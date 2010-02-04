Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab0BDCXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 21:23:08 -0500
Received: from mga03.intel.com ([143.182.124.21]:32605 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756044Ab0BDCXD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 21:23:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,402,1262592000"; 
   d="scan'208";a="240242612"
From: "Lu, Hongjiu" <hongjiu.lu@intel.com>
To: Roland McGrath <roland@redhat.com>
CC: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Lachner, Peter" <peter.lachner@intel.com>
Date: Wed, 3 Feb 2010 18:22:53 -0800
Subject: RE: [patch] x86: ptrace and core-dump extensions for xstate
Thread-Topic: [patch] x86: ptrace and core-dump extensions for xstate
Thread-Index: AcqlQFmSbfe0pQjSTb6kLKIjmgcF4wAABu8A
Message-ID: <8EA2C2C4116BF44AB370468FBF85A7770123AAB303@orsmsx504.amr.corp.intel.com>
References: <1265076025.2802.194.camel@sbs-t61.sc.intel.com>
	<20100203230817.E6529AA@magilla.sf.frob.com>
	<8EA2C2C4116BF44AB370468FBF85A7770123AAB0AE@orsmsx504.amr.corp.intel.com>
	<20100204020224.45379725@magilla.sf.frob.com>
	<8EA2C2C4116BF44AB370468FBF85A7770123AAB2E8@orsmsx504.amr.corp.intel.com>
 <20100204021659.AB348C880@magilla.sf.frob.com>
In-Reply-To: <20100204021659.AB348C880@magilla.sf.frob.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > That is how processor works.
> 
> We're not talking about the processor.
> We're talking about the API of a Linux system call.
> 
> 

To support XSAVE, gdb needs to know XCR0 as well as XSTATE size.
We can get those info from kernel via system call or cpuid. I
prefer cpuid over system call.


H.J.
