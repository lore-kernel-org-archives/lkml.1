Return-Path: <linux-kernel-owner+w=401wt.eu-S1757948AbXFDQUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbXFDQUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 12:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756030AbXFDQT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 12:19:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:12961 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268AbXFDQTz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 12:19:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,381,1175497200"; 
   d="scan'208";a="93314314"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [-mm patch] the ASYNC_* options shouldn't be user visible
Date: Mon, 4 Jun 2007 09:19:53 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E5201F0337F@azsmsx413.amr.corp.intel.com>
In-Reply-To: <20070602190907.GK5500@stusta.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [-mm patch] the ASYNC_* options shouldn't be user visible
Thread-Index: AcelSX2exxUkBaJrTpCaI5LkCr1HtwBeggWg
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: "Adrian Bunk" <bunk@stusta.de>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, "Herbert Xu" <herbert@gondor.apana.org.au>
X-OriginalArrivalTime: 04 Jun 2007 16:19:55.0086 (UTC) FILETIME=[2FE7A6E0:01C7A6C4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Adrian Bunk [mailto:bunk@stusta.de]
> >...
> > Changes since 2.6.22-rc2-mm1:
> >...
> >  git-md-accel.patch
> >...
> >  git trees
> >...
> 
> 
> The ASYNC_* options are for internal helper code and should therefore
> not be user visible.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> ---
> 
> BTW: Please move the async_tx directory under drivers/ or lib/
> 
Yes, I was feeling somewhat exposed with the options in the top level
config, but at least it got a few more eyes on the code.  I will fold in
your patch and move async_tx under lib/ for now, but at some point I
would like to investigate the potential synergies with crypto/.

Thanks,
Dan
