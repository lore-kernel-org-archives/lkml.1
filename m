Return-Path: <linux-kernel-owner+w=401wt.eu-S1759654AbXEUIwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759654AbXEUIwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 04:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbXEUIwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 04:52:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:46118 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754933AbXEUIwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 04:52:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,560,1170662400"; 
   d="scan'208";a="230280687"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.22-rc1-mm1 - s390 vs. md
Date: Mon, 21 May 2007 01:52:36 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E5201DEAE7F@azsmsx413.amr.corp.intel.com>
In-Reply-To: <20070521092449.34a50f2e@gondolin.boeblingen.de.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.22-rc1-mm1 - s390 vs. md
Thread-Index: AcebeSN/nnkYHvULSKKx95LFhHcs3AADAnfw
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: "Cornelia Huck" <cornelia.huck@de.ibm.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "NeilBrown" <neilb@suse.de>,
       "Martin Schwidefsky" <schwidefsky@de.ibm.com>,
       "linux-s390" <linux-s390@vger.kernel.org>
X-OriginalArrivalTime: 21 May 2007 08:52:38.0035 (UTC) FILETIME=[61FE2630:01C79B85]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Cornelia Huck [mailto:cornelia.huck@de.ibm.com]
> On Fri, 18 May 2007 09:30:09 -0700,
> "Williams, Dan J" <dan.j.williams@intel.com> wrote:
> 
> > When CONFIG_DMA_ENGINE=n async_tx_find_channel takes the form:
> > ... async_tx_find_channel( ... )
> > {
> > 	return NULL;
> > }
> >
> > So in the S390 case the entire asynchronous path will be compiled
away.
> 
> Unfortunately, do_async_xor() (and others) is not ifdef'ed and
contains
> dma_map_page(), which led to the compile failure...

Sorry, I did not realize dma_map_page did not exist on s390.  I am
building an s390 cross compiler so I can clean up these errors.
