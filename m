Return-Path: <linux-kernel-owner+w=401wt.eu-S1754275AbYHOUCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbYHOUCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 16:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751062AbYHOUCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 16:02:24 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:43257 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbYHOUCX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 16:02:23 -0400
X-BigFish: VPS-45(z21eWz1432R936eQ1805M936fQzzzzz32i6bh43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0K5NRNF-01-5JN-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 01/01][retry 5] x86: L3 cache index disable for 2.6.26
Date: Fri, 15 Aug 2008 15:02:12 -0500
Message-ID: <6453C3CB8E2B3646B0D020C112613273C5AC79@sausexmb4.amd.com>
In-Reply-To: <20080815195712.GC25185@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 01/01][retry 5] x86: L3 cache index disable for 2.6.26
Thread-Index: Acj/EUJlVv8FYXMFRQKBDda25u1TwwAAFtYg
References: <200807181603.52332.mark.langsdorf@amd.com> <200808141148.38108.mark.langsdorf@amd.com> <20080814171042.GA26985@kroah.com> <200808141332.53538.mark.langsdorf@amd.com> <20080815164213.GA29956@elte.hu> <6453C3CB8E2B3646B0D020C112613273C5AC78@sausexmb4.amd.com> <20080815195712.GC25185@elte.hu>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Ingo Molnar" <mingo@elte.hu>
CC: "Greg KH" <greg@kroah.com>, "Pavel Machek" <pavel@suse.cz>,
       "Deguara, Joachim" <joachim.deguara@amd.com>, <gregkh@ucw.cz>,
       <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 15 Aug 2008 20:02:13.0421 (UTC) FILETIME=[CF1A8DD0:01C8FF11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >  Author: Mark Langsdorf <mark.langsdorf@amd.com>
> > >  Date:   Tue Jul 22 13:06:02 2008 -0500
> > > 
> > >     x86: L3 cache index disable for 2.6.26
> > > 
> > > could you please send a delta patch against tip/master?
> > > 
> > >    http://people.redhat.com/mingo/tip.git/README
> > 
> > tip/master looks likes it has the version 5 of my patch
> > in it already.  Am I missing something?
> 
> ok, that's good - that's the latest, right?

Yes.  Single inline function with asm instructions and 
a documented clflush check in asm/processor.h and the 
call to wbinvd_halt() in both processor_32.c and 
processor_64.h.  It looks like we're done here.

-Mark Langsdorf
Operating System Research Center
AMD

