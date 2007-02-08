Return-Path: <linux-kernel-owner+w=401wt.eu-S933365AbXBHC7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365AbXBHC7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 21:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933359AbXBHC7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 21:59:47 -0500
Received: from mail0.lsil.com ([147.145.40.20]:36421 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933346AbXBHC7q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 21:59:46 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/5] scsi: megaraid_sas - stop cmd processing if hw_crit_error is set
Date: Wed, 7 Feb 2007 19:59:36 -0700
Message-ID: <0631C836DBF79F42B5A60C8C8D4E82298ED5D7@NAMAIL2.ad.lsil.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/5] scsi: megaraid_sas - stop cmd processing if hw_crit_error is set
Thread-Index: AcdK/XBllSr+tCNzTcuUUJX9hz3UPgAL5suw
From: "Patro, Sumant" <Sumant.Patro@lsi.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <James.Bottomley@SteelEye.com>, <linux-scsi@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, "Kolli, Neela" <Neela.Kolli@lsi.com>,
       "Yang, Bo" <Bo.Yang@lsi.com>
X-OriginalArrivalTime: 08 Feb 2007 02:59:37.0561 (UTC) FILETIME=[2B4FCC90:01C74B2D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I will correct the formatting and will resubmit.

Regards,
Sumant 

-----Original Message-----
From: Andrew Morton [mailto:akpm@linux-foundation.org] 
Sent: Wednesday, February 07, 2007 1:18 PM
To: Patro, Sumant
Cc: James.Bottomley@SteelEye.com; linux-scsi@vger.kernel.org;
linux-kernel@vger.kernel.org; Kolli, Neela; Yang, Bo; Patro, Sumant
Subject: Re: [PATCH 1/5] scsi: megaraid_sas - stop cmd processing if
hw_crit_error is set

On Tue, 06 Feb 2007 13:49:24 -0800
Sumant Patro <sumantp@lsil.com> wrote:

> +	/* Don't process if we have already declared adapter dead */
> +	if(instance->hw_crit_error)

Preferred kernel coding style is "if (".

> [p1-crit_err.patch  text/x-patch (1.3KB)]

argh.  Please don't send two copies of the patch in the email.  Because
the result applies happily with `patch --dry-run' and then creates a
great mess when you try to apply the patch for real.

