Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbZCBRAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbZCBRAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 12:00:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759924AbZCBQ7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 11:59:41 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:29569 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759906AbZCBQ7k convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 11:59:40 -0500
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Mar 2009 11:59:40 EST
X-BigFish: VPS-7(zz1432R1805Mzzzzz32i6bh68o)
X-Spam-TCS-SCL: 7:0
X-FB-SS: 5,
X-WSS-ID: 0KFW156-02-VPR-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH][retry 2] Conform L3 Cache Index Disable to Linuxstandards From:  Eric Lammerts <eric@lammerts.org>
Date: Mon, 2 Mar 2009 10:44:01 -0600
Message-ID: <6453C3CB8E2B3646B0D020C112613273C5AEF2@sausexmb4.amd.com>
In-Reply-To: <20090227080246.GA524@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH][retry 2] Conform L3 Cache Index Disable to Linuxstandards From:  Eric Lammerts <eric@lammerts.org>
Thread-Index: AcmYsdHB/iBuuT6ZQfG0SlICJFY+PgCoY5Gg
References: <200902201550.47415.mark.langsdorf@amd.com> <20090226163329.3a47b368.akpm@linux-foundation.org> <20090227080246.GA524@elte.hu>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <eric@lammerts.org>
X-OriginalArrivalTime: 02 Mar 2009 16:44:02.0073 (UTC) FILETIME=[17831890:01C99B56]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Add ABI Documentation entry and fix some /sys directory formating
> > > issues with the L3 Cache Index Disable feature for future AMD
> > > processors. __Add a check to disable it for family 0x10 models
> > > that do not support it yet.
> > 
> > x86_64 allnoconfig:
> > 
> > arch/x86/kernel/cpu/intel_cacheinfo.c:556: warning: 
> 'free_cache_attributes' defined but not used
> > arch/x86/kernel/cpu/intel_cacheinfo.c:596: warning: 
> 'detect_cache_attributes' defined but not used

My code doesn't modify either of these functions, so
I'm not causing the regression.

Also, I can't reproduce this error on the current head of 
Ingo's tree:
http://people.redhat.com/mingo/tip.git/readme.txt

I do `make allnoconfig; make all` without errors, apply
my patch, and do `make all` again without errors.

> > I'll drop the patches.  Please test version 3 a bit better?
> 
> Yes. I'll pick it up into the x86 tree once it works and builds 
> warning-free.

-Mark Langsdorf
Operating System Research Center
AMD

