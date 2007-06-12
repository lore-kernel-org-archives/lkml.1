Return-Path: <linux-kernel-owner+w=401wt.eu-S1757577AbXFLP7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbXFLP7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 11:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755718AbXFLP71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 11:59:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:10799 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755298AbXFLP70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 11:59:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,412,1175497200"; 
   d="scan'208";a="255996020"
Date: Tue, 12 Jun 2007 08:56:00 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, jeff@garzik.org,
       james.bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 0/3] AHCI Link Power Management
Message-Id: <20070612085600.72d02b19.kristen.c.accardi@intel.com>
In-Reply-To: <466E23AF.9060002@gmail.com>
References: <20070611114600.7fca1c24.kristen.c.accardi@intel.com>
	<466DFDB5.9030901@gmail.com>
	<466E0642.5020506@linux.intel.com>
	<466E1D51.9070007@gmail.com>
	<466E1EC6.90509@linux.intel.com>
	<466E23AF.9060002@gmail.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2007 13:40:15 +0900
Tejun Heo <htejun@gmail.com> wrote:

> I don't think the end result will vary in any significant way.  My
> biggest argument for sw implementation is it can be used for other
> controllers.

What I had in mind when I created the new port operation "enable_pm"
was that other controllers (besides the ahci controller) could define their
own method of enabling power management.  Maybe for non-ahci controllers this
is a software based solution which uses generic SATA dipm/hipm stuff and 
polling.  

See patch 2/3 of this series for the implementation of this.

Kristen
