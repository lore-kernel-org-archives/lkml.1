Return-Path: <linux-kernel-owner+w=401wt.eu-S1762618AbXJXQoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762618AbXJXQoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760076AbXJXQZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:25:58 -0400
Received: from ts.adaptec.com ([162.62.93.58]:58313 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760059AbXJXQZz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:25:55 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH -mm 11/11] aacraid: use pci_set_dma_max_seg_size
Date: Wed, 24 Oct 2007 12:25:52 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01F3DB6C@otce2k301.adaptec.com>
In-Reply-To: <20071025012348Z.tomof@acm.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH -mm 11/11] aacraid: use pci_set_dma_max_seg_size
Thread-Index: AcgWWfPD+VeWx4DKTAO6dBDpHcYu6QAACvcw
References: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org><20071024173019I.tomof@acm.org><AE4F746F2AECFC4DA4AADD66A1DFEF01F3DAB4@otce2k301.adaptec.com> <20071025012348Z.tomof@acm.org>
From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
To: "FUJITA Tomonori" <tomof@acm.org>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <linux-scsi@vger.kernel.org>, <James.Bottomley@SteelEye.com>,
       "AACRAID" <aacraid@adaptec.com>, <fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Not requesting you to test (aacraid), just scoping any effort.

The cards in question are the (old) Dell PERC variety that would trigger
the need. I will notify our Dell liaison to see what they can do.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: FUJITA Tomonori [mailto:tomof@acm.org] 
> Sent: Wednesday, October 24, 2007 12:22 PM
> To: Salyzyn, Mark
> Cc: tomof@acm.org; akpm@linux-foundation.org; 
> linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; 
> James.Bottomley@SteelEye.com; AACRAID; fujita.tomonori@lab.ntt.co.jp
> Subject: RE: [PATCH -mm 11/11] aacraid: use pci_set_dma_max_seg_size
> 
> On Wed, 24 Oct 2007 09:34:23 -0400
> "Salyzyn, Mark" <mark_salyzyn@adaptec.com> wrote:
> 
> > ACK
> 
> Thanks.
> 
> > Based on the presence of the call. 2.6.22, for instance, 
> does not have
> > this capability...
> > 
> > I did not test this change, just accepting on the 
> principals. How much
> > testing of the change did you do Fujita?
> 
> Unfortunately, I tested only the main component (device and pci
> changes) with ppc64 IOMMU. I don't have the other IOMMUs.
> 
> I didn't test the aacraid patch but I guess that I have aacraid in the
> workplace so I can test the patch (without the IOMMU chages).
> 
