Return-Path: <linux-kernel-owner+w=401wt.eu-S1758185AbZD1Bbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbZD1Bbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 21:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbZD1Bba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 21:31:30 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:54244 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458AbZD1Bb3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 21:31:29 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] fsldma: use PCI Read Multiple command
Date: Tue, 28 Apr 2009 09:31:08 +0800
Message-ID: <D7CCA83BB0796C49BC0BB53B6AB1208928CAB2@zch01exm21.fsl.freescale.net>
In-Reply-To: <ed82fe3e0904270731g2d2519a7mc12e4152c716c0a9@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] fsldma: use PCI Read Multiple command
Thread-Index: AcnHRPdBWwGiOijVTWu5E4TWalmxaAAW+Frg
References: <20090424183517.GB23140@ovro.caltech.edu> <D7CCA83BB0796C49BC0BB53B6AB1208928CA1D@zch01exm21.fsl.freescale.net> <ed82fe3e0904270731g2d2519a7mc12e4152c716c0a9@mail.gmail.com>
From: "Liu Dave-R63238" <DaveLiu@freescale.com>
To: "Tabi Timur-B04825" <timur@freescale.com>
Cc: "Ira Snyder" <iws@ovro.caltech.edu>, <linux-kernel@vger.kernel.org>,
       <linuxppc-dev@ozlabs.org>, "Dan Williams" <dan.j.williams@intel.com>,
       "Li Yang-R58472" <LeoLi@freescale.com>
X-Brightmail-Tracker: AAAAAQAAAWE=
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > You are assuming the PCI memory space is prefetchable( no 
> > side effect) for DMA.
> > Is it possible that DMA is from non-prefetchable memory space?
> 
> This should be a safe assumption for this driver.  Remember, this
> driver just does offload memcpy, from one region to another.  So the
> PCI memory that you are reading from should be just a buffer of data,
> and there should be side-effect of reading it.
> 
> However, I would like to see a comment at the top of the file warning
> people that copying from PCI memory will result in prefetched reads.

How about FIFO RAM case?
