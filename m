Return-Path: <linux-kernel-owner+w=401wt.eu-S932398AbXHOQYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbXHOQYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 12:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbXHOQYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 12:24:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:36646 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760206AbXHOQYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 12:24:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,267,1183359600"; 
   d="scan'208";a="117867902"
Date: Wed, 15 Aug 2007 09:21:13 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: James.Bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch 1/4] libata: check for AN support
Message-Id: <20070815092113.f6546e76.kristen.c.accardi@intel.com>
In-Reply-To: <46C2B24E.1010506@garzik.org>
References: <20070808190613.616085010@localhost.localdomain>
	<20070808120810.5f8ed457.kristen.c.accardi@intel.com>
	<46C2B24E.1010506@garzik.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2007 03:59:10 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Since I wanted to get in Tejun's ata_link changes before this, this will 
> require a rediff.
> 
> But more importantly, as I was going to apply it I noticed another 
> problem:  we need to verify that SiS and NVIDIA both support AN support 
> turning this on, since this patch affects not only Intel but also those 
> vendors' AHCI hardware as well.
> 
> It's a bit annoying but this is a cross-vendor driver after all...
> 
> 	Jeff

Got a link to their public docs?  I'm happy to look in their specs to confirm.
Otherwise, maybe you can forward to people there to have them check, or find
someone under NDA with them who can.

Kristen
