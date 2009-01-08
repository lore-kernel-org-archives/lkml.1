Return-Path: <linux-kernel-owner+w=401wt.eu-S1756741AbZAHBMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbZAHBMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 20:12:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754744AbZAHBMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 20:12:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:23293 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbZAHBMh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 20:12:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,229,1231142400"; 
   d="scan'208";a="479813170"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, "holt@sgi.com" <holt@sgi.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "ptesarik@suse.cz" <ptesarik@suse.cz>, "tee@sgi.com" <tee@sgi.com>,
       "holt@sgi.com" <holt@sgi.com>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "mingo@elte.hu" <mingo@elte.hu>
Date: Wed, 7 Jan 2009 16:05:22 -0800
Subject: RE: [Patch V3 0/3] Enable irqs when waiting for rwlocks
Thread-Topic: [Patch V3 0/3] Enable irqs when waiting for rwlocks
Thread-Index: AclxIKQamRHkFh/BRQ2a0NH8Itm4sQAA1oEw
Message-ID: <57C9024A16AD2D4C97DC78E552063EA35CBE569C@orsmsx505.amr.corp.intel.com>
References: <20081104122405.046233722@attica.americas.sgi.com>
 <20090107153520.b91b5956.akpm@linux-foundation.org>
In-Reply-To: <20090107153520.b91b5956.akpm@linux-foundation.org>
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

> > SGI has observed that on large systems, interrupts are not serviced for
> > a long period of time when waiting for a rwlock. The following patch
> > series re-enables irqs while waiting for the lock, resembling the code
> > which is already there for spinlocks.

> I'm not seeing any Tony Luck acks on this work?

I was initially concerned about how to get enough testing
for this to gain confidence that it doesn't unexpectedly
break something.  But Robin pointed out that Novell has
been shipping an equivalent patch in SLES10 without seeing
anything nasty.

Acked-by: Tony Luck <tony.luck@intel.com>
