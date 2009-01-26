Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbZAZTjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbZAZTjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 14:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbZAZTjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 14:39:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:30910 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbZAZTjI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 14:39:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,327,1231142400"; 
   d="scan'208";a="425607961"
From: "Luck, Tony" <tony.luck@intel.com>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Papi <ptools-perfapi@cs.utk.edu>,
       "David S. Miller" <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Paul Mackerras <paulus@samba.org>,
       Peter Anvin <hpa@zytor.com>, "eranian@gmail.com" <eranian@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "perfmon2-devel@lists.sourceforge.net" 
	<perfmon2-devel@lists.sourceforge.net>,
       Arjan van de Ven <arjan@infradead.org>
Date: Mon, 26 Jan 2009 11:39:06 -0800
Subject: RE: [perfmon2] [announce] Performance Counters for Linux, v6
Thread-Topic: [perfmon2] [announce] Performance Counters for Linux, v6
Thread-Index: Acl/6l9347dx2B6ZQwCEaPsSFZMW0gAAZ9yw
Message-ID: <57C9024A16AD2D4C97DC78E552063EA35F1F9374@orsmsx505.amr.corp.intel.com>
References: <20090121185021.GA8852@elte.hu>
	<497D0C81.5040406@linux.vnet.ibm.com>
	<7c86c4470901260113r4db6b15cpa0fa88ab3f8a516c@mail.gmail.com>
	<20090126151746.GH9128@elte.hu> <497E0B55.4050408@linux.vnet.ibm.com>
In-Reply-To: <497E0B55.4050408@linux.vnet.ibm.com>
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

> - or the PMU capability is expressed as a special counter type (if it's
>   useful enough) - and then either the write() method or ioctl is extended
>   to express attributes we want to set/change while a counter is running.

The product of:
        {exotic PMU modes} * {creative performance measurement ideas}
will produce a large number of candidates for these special counters
(at least on ia64 ... which has a large number of exotic PMU options).

I don't think that I'm qualified to judge which of them are "useful enough"
to warrant a special counter type.

-Tony
