Return-Path: <linux-kernel-owner+w=401wt.eu-S1762792AbZE2QNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762792AbZE2QNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 12:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760664AbZE2QNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 12:13:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:35482 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757472AbZE2QNK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 12:13:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,272,1241420400"; 
   d="scan'208";a="416839614"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Philip Mucci <mucci@eecs.utk.edu>, LKML <linux-kernel@vger.kernel.org>,
       Maynard Johnson <mpjohn@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, "eranian@gmail.com" <eranian@gmail.com>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Date: Fri, 29 May 2009 09:13:10 -0700
Subject: RE: [perfmon2] comments on Performance Counters for Linux (PCL)
Thread-Topic: [perfmon2] comments on Performance Counters for Linux (PCL)
Thread-Index: AcngOghPpsmvHA13Q1iYuPmurkylEQAPfLPQ
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3A87392E6@orsmsx505.amr.corp.intel.com>
References: <7c86c4470905280758y6d359823h2a7517dfecb115e6@mail.gmail.com>
	<1243527919.6645.75.camel@laptop>	<20090529065104.GO1065@one.firstfloor.org>
	<1243585158.23657.175.camel@twins> <20090529085309.GP1065@one.firstfloor.org>
In-Reply-To: <20090529085309.GP1065@one.firstfloor.org>
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

>> Happen to have more details? If they really run in user context their
>> priv level would be the same right, otherwise they run in something
>> weird, not quite user not quite kernel. Now that might be the case, but
>> I'm utterly ignorant on itanic.
>
> See Documentation/ia64/fsys.txt

Summary is that the fast system calls run in ring 0 ... but since they
didn't save all the user state (in order to make them fast!) there are
restrictions on what things they can do.  In particular they must not
trap.

-Tony
