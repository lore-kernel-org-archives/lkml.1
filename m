Return-Path: <linux-kernel-owner+w=401wt.eu-S1752094AbXB0V2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbXB0V2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 16:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbXB0V2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 16:28:25 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:52013 "EHLO
	outbound8-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752094AbXB0V2Y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 16:28:24 -0500
X-BigFish: VP
X-Server-Uuid: 519AC16A-9632-469E-B354-112C592D09E8
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 09/14] x86_64 irq: Begin consolidating per_irq data
 in structures.
Date: Tue, 27 Feb 2007 13:28:07 -0800
Message-ID: <5986589C150B2F49A46483AC44C7BCA4907458@ssvlexmb2.amd.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 09/14] x86_64 irq: Begin consolidating per_irq data
 in structures.
Thread-Index: AcdXPnLVJLk1vc4pTbGzNOHZTHAGIgDd3jdg
From: "Lu, Yinghai" <yinghai.lu@amd.com>
To: ebiederm@xmission.com, "Andrew Morton" <akpm@osdl.org>
cc: linux-kernel@vger.kernel.org, "Zwane Mwaikambo" <zwane@infradead.org>,
       "Ashok Raj" <ashok.raj@intel.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Natalie Protasevich" <protasnb@gmail.com>, "Andi Kleen" <ak@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
X-OriginalArrivalTime: 27 Feb 2007 21:28:08.0417 (UTC)
 FILETIME=[2CB84510:01C75AB6]
X-WSS-ID: 69FA7DE22X01527216-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-----Original Message-----
From: ebiederm@xmission.com [mailto:ebiederm@xmission.com] 
Sent: Friday, February 23, 2007 3:33 AM

>+struct irq_cfg {
>+	cpumask_t domain;
>+	u8 vector;
>+};
>+
>+/* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
>+struct irq_cfg irq_cfg[NR_IRQS] __read_mostly = {
>+	[0] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR
+ 0 },
>+	[1] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR
+ 1 },
>+	[2] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR
+ 2 },
>+	[3] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR
+ 3 },
>+	[4] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR
+ 4 },
>+	[5] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR
+ 5 },
>+	[6] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR
+ 6 },
>+	[7] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR
+ 7 },
>+	[8] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR
+ 8 },
>+	[9] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR
+ 9 },
>+	[10] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR
+ 10 },
>+	[11] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR
+ 11 },
>+	[12] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR
+ 12 },
>+	[13] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR
+ 13 },
>+	[14] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR
+ 14 },
>+	[15] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR
+ 15 },
>+};
>+
> static int assign_irq_vector(int irq, cpumask_t mask, cpumask_t
*result);

Why not use

IRQ0_VECTOR... IRQ15_VECTOR here. 

YH


