Return-Path: <linux-kernel-owner+w=401wt.eu-S937430AbXGMX2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937430AbXGMX2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 19:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760762AbXGMX2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 19:28:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:46263 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760745AbXGMX2a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 19:28:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,538,1175497200"; 
   d="scan'208";a="250185346"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [-mm PATCH 0/2] 74% decrease in dispatched writes, stripe-queue take3
Date: Fri, 13 Jul 2007 16:28:30 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E5202234496@azsmsx413.amr.corp.intel.com>
In-Reply-To: <20070713160117.0db9d36d.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [-mm PATCH 0/2] 74% decrease in dispatched writes, stripe-queue take3
Thread-Index: AcfFocKNdMc3L90WRJqUEBTU9gEmPQAABNnQ
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <neilb@suse.de>, <raziebe@gmail.com>, <linux-raid@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>,
       "Nelson, Shannon" <shannon.nelson@intel.com>
X-OriginalArrivalTime: 13 Jul 2007 23:28:29.0959 (UTC) FILETIME=[85462170:01C7C5A5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> 
> But your ongoing maintenance activity will continue to be held in
those
> trees, won't it?

For now:
	git://lost.foo-projects.org/~dwillia2/git/iop
ioat-md-accel-for-linus

is where the latest combined tree is located.  However, Shannon Nelson
is coming online to own the i/oat driver so we may need to revisit this
situation.  We want to avoid the git-ioat/git-md-accel collisions that
happened in the past.  I will talk with Shannon about how we will
coordinate this going forward.

The code ownership looks like this:
ioat dma driver - Shannon
net dma offload implementation - Shannon
dmaengine core - shared
async_tx api - shared
iop-adma dma driver - Dan
md-accel implementation - Dan
