Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbYG1O5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbYG1O5d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 10:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756711AbYG1Oy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 10:54:59 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:22760 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757377AbYG1Oy6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 10:54:58 -0400
X-BigFish: VPS-27(z21eW37d4lz1432R1805M103dK7cf0izzzzz32i6bh65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K4Q1FA-01-JJC-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 01/01] x86: L3 cache index disable for 2.6.26
Date: Mon, 28 Jul 2008 09:54:52 -0500
Message-ID: <6453C3CB8E2B3646B0D020C112613273C5AC2E@sausexmb4.amd.com>
In-Reply-To: <20080728144913.GA16147@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 01/01] x86: L3 cache index disable for 2.6.26
Thread-Index: AcjwwVLW2k5VNh+qQaanqvYSFuz0LAAAH3wg
References: <200807181603.52332.mark.langsdorf@amd.com> <20080721113706.GC23095@elte.hu> <20080721124812.GA25371@elte.hu> <200807221306.03123.mark.langsdorf@amd.com> <20080728142256.GF18144@elte.hu> <20080728144913.GA16147@elte.hu>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Ingo Molnar" <mingo@elte.hu>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 28 Jul 2008 14:54:52.0788 (UTC) FILETIME=[E431C340:01C8F0C1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > please send a delta fix patch against the tip/x86/cpu branch:
> > > > 
> > > >   http://people.redhat.com/mingo/tip.git/README
> > > > 
> > > > which has your patch plus the cleanup applied.
> > > 
> > > delta fix patch follows.  It removes the dependency on 
> k8_northbridges.
> > 
> > applied, thanks. I fixed up some whitespace damage, see below. That 
> > file could use a thorough cleanup ...
> 
> it still doesnt work, on !PCI:
> 
> arch/x86/kernel/cpu/intel_cacheinfo.c: In function 
> 'get_k8_northbridge':
> arch/x86/kernel/cpu/intel_cacheinfo.c:675: error: implicit 
> declaration of function 'pci_match_id'
> make[2]: *** [arch/x86/kernel/cpu/intel_cacheinfo.o] Error 1
> 
> config and fix attached.

Thanks!

-Mark Langsdorf
Operating System Research Center
AMD

