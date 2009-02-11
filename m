Return-Path: <linux-kernel-owner+w=401wt.eu-S1757549AbZBKR5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbZBKR5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 12:57:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbZBKR5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 12:57:12 -0500
Received: from mga11.intel.com ([192.55.52.93]:3842 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059AbZBKR5M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:57:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,193,1233561600"; 
   d="scan'208";a="430165812"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Mike Travis <travis@sgi.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>,
       "kaneshige.kenji@jp.fujitsu.com" <kaneshige.kenji@jp.fujitsu.com>
Date: Wed, 11 Feb 2009 09:57:00 -0800
Subject: RE: [PATCH 0/8] git pull request for tip/tracing/core
Thread-Topic: [PATCH 0/8] git pull request for tip/tracing/core
Thread-Index: AcmMbp96sP13ebmuS9yFpDYPKkTOKwAAnQ/A
Message-ID: <57C9024A16AD2D4C97DC78E552063EA361689C3B@orsmsx505.amr.corp.intel.com>
References: <20090208054955.777429253@goodmis.org>
 <20090209093751.GD7930@elte.hu> <20090211153650.GA19576@elte.hu>
 <alpine.DEB.1.10.0902111147450.15438@gandalf.stny.rr.com>
 <alpine.DEB.1.10.0902111158380.15438@gandalf.stny.rr.com>
 <20090211171622.GA13239@elte.hu>
 <alpine.DEB.1.10.0902111227570.15438@gandalf.stny.rr.com>
 <20090211173131.GA27546@elte.hu>
In-Reply-To: <20090211173131.GA27546@elte.hu>
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

> > Before we go and make the change, Peter brought up a good point on IRC. Is
> > there any reason that ia64 needs 1 << 14 IRQs?  That's 16384!
> >
> > Perhaps the better solution wolud be (if possible), to simply lower the
> > number of bits.
>
> i'm the wrong person to be asked about that. (Cc:-ed the right people)

People build some pretty big systems on ia64.  SGI's largest has 4096
cpus ... so 16384 IRQs is only 4 per cpu.  That doesn't sound like very
many to me.

Fujitsu added the vector domain support for ia64 to get around the shortage
of IRQs for large machines.  Added them to the Cc: list to see if they have
comments on how many IRQs are needed.

-Tony
