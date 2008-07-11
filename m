Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbYGKQZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbYGKQZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 12:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbYGKQZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 12:25:07 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:19266 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbYGKQZG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 12:25:06 -0400
X-BigFish: VPS-33(zz1432R98dR7efV1805M19c2kzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K3UO94-01-I0V-01
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 00/34] AMD IOMMU driver
Date: Fri, 11 Jul 2008 11:23:46 -0500
Message-ID: <6453C3CB8E2B3646B0D020C1126132730149A6C6@sausexmb4.amd.com>
In-Reply-To: <m1d4lk90vq.fsf@frodo.ebiederm.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-topic: [PATCH 00/34] AMD IOMMU driver
Thread-index: Acjjb+D9/QRR/Zp2Rxm28fDRDFIgdQAAW7mw
From: "Duran, Leo" <leo.duran@amd.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: "Richter, Robert" <rrichter@elbe.amd.com>,
       "Biemueller, Sebastian" <Sebastian.Biemueller@amd.com>,
       <linux-kernel@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
       <mingo@redhat.com>, <tglx@linutronix.de>,
       "Sarathy, Bhavna" <Bhavna.Sarathy@amd.com>
X-OriginalArrivalTime: 11 Jul 2008 16:24:47.0737 (UTC) FILETIME=[A2CFE690:01C8E372]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 11, 2008 5:22 AM, Eric W. Biederman wrote:

> Small question.  Does this IOMMU also support irq remapping?
> 
> Intel is starting to merge support for their iommu that supports irq
> remapping and I am curious what the implications are going to be to
> support both of these iommus?
> 
> Assuming their is irq remapping support it isn't tied to x2apic
> support in the cpus is it?
> 
Follow-up questions: 
(1) Outside of a virtualization environment, is there functional value
for "irq remapping" by an IOMMU? And, if there is, (2) How would this
functionality get abstracted? (e.g., as dma_ops abstracts 'address
remapping' by the IOMMU)

Leo.

