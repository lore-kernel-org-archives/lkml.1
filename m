Return-Path: <linux-kernel-owner+w=401wt.eu-S933085AbXBEX7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085AbXBEX7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 18:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933100AbXBEX7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 18:59:20 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:59784 "EHLO
	mail24-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933085AbXBEX7T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 18:59:19 -0500
X-Greylist: delayed 1476 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Feb 2007 18:59:19 EST
X-BigFish: VP
X-Server-Uuid: 519AC16A-9632-469E-B354-112C592D09E8
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 2/2] x86_64 irq: Handle irqs pending in IRR during
 irq migration.
Date: Mon, 5 Feb 2007 15:33:36 -0800
Message-ID: <5986589C150B2F49A46483AC44C7BCA4907417@ssvlexmb2.amd.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] x86_64 irq: Handle irqs pending in IRR during
 irq migration.
Thread-Index: AcdJeepBQmD4q4NsSdinZ1C/+kuC+wAA8dqA
From: "Lu, Yinghai" <yinghai.lu@amd.com>
To: ebiederm@xmission.com
cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, "Luigi Genoni" <luigi.genoni@pirelli.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Natalie Protasevich" <protasnb@gmail.com>
X-OriginalArrivalTime: 05 Feb 2007 23:33:37.0160 (UTC)
 FILETIME=[0F1CC880:01C7497E]
X-WSS-ID: 69D9615A0T06159839-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: ebiederm@xmission.com [mailto:ebiederm@xmission.com] 
Sent: Monday, February 05, 2007 3:03 PM
>Nope. irq routines are a stack.  if apic_in_service_vector could return
>the wrong value.  ack_APIC_irq() which use the same information would
>acknowledge the wrong irq.  If there was actually any danger of
>mis-computing that information I would just pass it from the interrupt
>service routine stash it in a per cpu variable and then read it out.
>But the apic already has registers doing that, so I was lazy and used
>what was available.  It should be the common case that we need that
>information.

OK.

I wonder if current kernel support different cpu handle irq request for
different device at the same time.

YH


