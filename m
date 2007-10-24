Return-Path: <linux-kernel-owner+w=401wt.eu-S1759268AbXJXNez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268AbXJXNez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 09:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757919AbXJXNec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 09:34:32 -0400
Received: from ts.adaptec.com ([162.62.93.58]:54527 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757953AbXJXNea convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 09:34:30 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH -mm 11/11] aacraid: use pci_set_dma_max_seg_size
Date: Wed, 24 Oct 2007 09:34:25 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01F3DAB5@otce2k301.adaptec.com>
In-Reply-To: <471F2D12.50006@garzik.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH -mm 11/11] aacraid: use pci_set_dma_max_seg_size
Thread-Index: AcgWMXP1zstOa2BsQ56UiZI3u7MvLgADlIGw
References: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org> <20071024173019I.tomof@acm.org> <471F2D12.50006@garzik.org>
From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
To: "Jeff Garzik" <jeff@garzik.org>, "FUJITA Tomonori" <tomof@acm.org>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <linux-scsi@vger.kernel.org>, <James.Bottomley@SteelEye.com>,
       "AACRAID" <aacraid@adaptec.com>, <fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik [mailto:jeff@garzik.org] writes:
> is this needed, given that the default is already 65536?

Apparently so, as we had to add it in the past, mainly because the
feature to limit was not part of the SCSI layer when the original limit
code was added. At that time it replaced a complicated sg breakup
algorithm.

Does your statement guarantee that the default will not change to a
large value? If not, then we need to enforce it in perpetuity...

Sincerely -- Mark Salyzyn
