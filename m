Return-Path: <linux-kernel-owner+w=401wt.eu-S1759399AbXJKVzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399AbXJKVzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 17:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758536AbXJKVzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 17:55:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:50807 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758162AbXJKVzQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 17:55:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,261,1188802800"; 
   d="scan'208";a="342664123"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: TPM driver changes to support multiple locality
Date: Thu, 11 Oct 2007 14:55:14 -0700
Message-ID: <A3258B497F1C1441AD36A2E8B45FD628CB9D42@scsmsx412.amr.corp.intel.com>
In-Reply-To: <20071011144112.0e408dce@laptopd505.fenrus.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: TPM driver changes to support multiple locality
Thread-Index: AcgMT7Uqs7eaEzvMSPu5vw7EGrnoXgAAXMEQ
References: <A3258B497F1C1441AD36A2E8B45FD628C7D657@scsmsx412.amr.corp.intel.com><27383.1192045583@turing-police.cc.vt.edu><A3258B497F1C1441AD36A2E8B45FD628CB9AEE@scsmsx412.amr.corp.intel.com> <20071011144112.0e408dce@laptopd505.fenrus.org>
From: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
To: "Arjan van de Ven" <arjan@linux.intel.com>
Cc: <Valdis.Kletnieks@vt.edu>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 11 Oct 2007 21:55:15.0833 (UTC) FILETIME=[6817BE90:01C80C51]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Arjan van de Ven [mailto:arjan@linux.intel.com] 
Sent: Thursday, October 11, 2007 2:41 PM
To: Agarwal, Lomesh
Cc: Valdis.Kletnieks@vt.edu; linux-kernel@vger.kernel.org
Subject: Re: TPM driver changes to support multiple locality

On Thu, 11 Oct 2007 11:33:35 -0700
"Agarwal, Lomesh" <lomesh.agarwal@intel.com> wrote:

> Below is the patch for TPM driver.
> Comments/suggestions?

please don't top post

> 
> --- pristine-linux-2.6.18/drivers/char/tpm/tpm_tis.c	2006-09-19
> 20:42:06.000000000 -0700
> +++ linux-2.6.18-xen/drivers/char/tpm/tpm_tis.c	2007-10-09
> 15:30:49.000000000 -0700

or send word wrapped patches ....

.. or patches against 2 year old kernels for that matter ;)

>  enum tis_defaults {
>  	TIS_MEM_BASE = 0xFED40000,
> -	TIS_MEM_LEN = 0x5000,
> +	TIS_MEM_LEN = 0x1000,

hmmm/// why
[Agarwal, Lomesh] 0x5000 is the length of CSRs for all the localities.
Each locality's CSR size is 0x1000. so 0x1000 is sufficient and will
catch error if driver tries to write to wrong locality.
