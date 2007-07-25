Return-Path: <linux-kernel-owner+w=401wt.eu-S1762798AbXGYTNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762798AbXGYTNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 15:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758879AbXGYTM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 15:12:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:11204 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453AbXGYTMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 15:12:54 -0400
Date: Wed, 25 Jul 2007 22:12:57 +0300
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       James Bottomley <James.Bottomley@steeleye.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org,
       Roland Dreier <rdreier@cisco.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       general@lists.openfabrics.org
Subject: Re: [PATCH trivial] include linux/mutex.h from scsi_transport_iscsi.h
Message-ID: <20070725191257.GA2311@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <20070725110907.GF3826@mellanox.co.il> <46A79C00.200@cs.wisc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A79C00.200@cs.wisc.edu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Mike Christie <michaelc@cs.wisc.edu>:
> Subject: Re: [PATCH trivial] include linux/mutex.h from scsi_transport_iscsi.h
> 
> Michael S. Tsirkin wrote:
> >scsi/scsi_transport_iscsi.h uses struct mutex, so while
> >linux/mutex.h seems to be pulled in indirectly
> >by one of the headers it includes, the right thing
> >is to include linux/mutex.h directly.
> >
> 
> Is that part about always including the header directly right?

Think so. Analogous patches by me has been accepted in various
subsystems. See e.g. f8916c11a4dc4cb2367e9bee1788f4e0f1b4eabc.

> If so 
> then were you going to include list.h too,

Makes sense. I'll repost.

> and were you going to fix up 
> some of the other iscsi code?

Not at the moment.
The reason I noticed this is because I'm doing some other project.
I'll post patches for other files if/when I notice any issues.

-- 
MST
