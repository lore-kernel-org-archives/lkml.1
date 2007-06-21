Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbXFUBjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbXFUBjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 21:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbXFUBj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 21:39:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:56647 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383AbXFUBj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 21:39:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,445,1175497200"; 
   d="scan'208";a="98625893"
Subject: Re: [PATCH] driver core: multithreaded probing - more parallelism
	control
From: "Huang, Ying" <ying.huang@intel.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Greg K-H <greg@kroah.com>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       Adrian Bunk <bunk@stusta.de>, "david@lang.hm" <david@lang.hm>,
       David Miller <davem@davemloft.net>,
       Duncan Sands <duncan.sands@math.u-psud.fr>,
       Phillip Susi <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <46794343.3080204@s5r6.in-berlin.de>
References: <1182373258.30574.30.camel@caritas-dev.intel.com>
	 <46794343.3080204@s5r6.in-berlin.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 21 Jun 2007 09:38:31 +0000
Message-Id: <1182418711.12959.3.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
X-OriginalArrivalTime: 21 Jun 2007 01:39:23.0780 (UTC) FILETIME=[FF03DC40:01C7B3A4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-20 at 17:09 +0200, Stefan Richter wrote:
> I'd call it probe_queue_number or maybe probe_queue_id.  The term "no"
> is ambiguous.

Yes, I think probe_queue_id is better.

> Is the queue number kernel-global or per subsystem?

The queue number is kernel-global. I think this is easy to be
implemented. And the serialization demand between subsystem can be
satisfied too.

> > + * @probe: probing infromation include probing function and parameter
>                       ^^^^^^^^^^^
> typo: information

Sorry, I will correct it in the next version.

Best Regards,
Huang Ying
