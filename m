Return-Path: <linux-kernel-owner+w=401wt.eu-S1757288AbXFLPq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbXFLPq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 11:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbXFLPqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 11:46:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:33737 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbXFLPqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 11:46:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,412,1175497200"; 
   d="scan'208";a="95815396"
Date: Tue, 12 Jun 2007 08:43:19 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Tejun Heo <htejun@gmail.com>,
       james.bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 0/3] AHCI Link Power Management
Message-Id: <20070612084319.b2e69248.kristen.c.accardi@intel.com>
In-Reply-To: <466E2460.3050703@garzik.org>
References: <20070611114600.7fca1c24.kristen.c.accardi@intel.com>
	<466DFDB5.9030901@gmail.com>
	<466E0642.5020506@linux.intel.com>
	<466E1D51.9070007@gmail.com>
	<466E1EC6.90509@linux.intel.com>
	<466E2460.3050703@garzik.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2007 00:43:12 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> We will do AHCI link PM -- presuming that I can be convinced that it 
> does not repeatedly park the hard drive heads, or something similarly 
> annoying on PATA<->SATA bridges and similar setups.
> 
> IF it works as advertised -- a big if considering all the AHCI silicon 
> implementations out there -- we definitely want to use it.
> 
> 	Jeff
> 

I understand that this is a concern of yours based on some experience you
had with earlier controllers.  In general, this behavior would be considered
incorrect - link power management should not translate to disk parking, even
on PATA->SATA brigdes, and if it does, then that's completely broken.  That 
said, I would believe you if you said broken hardware exists, and when you 
get specific examples of it, you can add it to the blacklist for this feature.
