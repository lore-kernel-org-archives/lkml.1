Return-Path: <linux-kernel-owner+w=401wt.eu-S1759691AbXFDSZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759691AbXFDSZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 14:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757416AbXFDSZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 14:25:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:8026 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754416AbXFDSZE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 14:25:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,381,1175497200"; 
   d="scan'208";a="93357728"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [-mm patch] the ASYNC_* options shouldn't be user visible
Date: Mon, 4 Jun 2007 11:25:02 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E5201F0351F@azsmsx413.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [-mm patch] the ASYNC_* options shouldn't be user visible
Thread-Index: AcelSX2exxUkBaJrTpCaI5LkCr1HtwBeggWgAARLdHA=
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: "Adrian Bunk" <bunk@stusta.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Herbert Xu" <herbert@gondor.apana.org.au>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 04 Jun 2007 18:25:03.0487 (UTC) FILETIME=[AB42B8F0:01C7A6D5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Williams, Dan J
> >
> > BTW: Please move the async_tx directory under drivers/ or lib/
> >
One caveat with this... md.o needs xor.o to be initialized first.
Moving xor.o under lib/ means this assumption is broken since the
top-level Makefile puts 'libs' after 'drivers'.

> Yes, I was feeling somewhat exposed with the options in the top level
config,
> but at least it got a few more eyes on the code.  I will fold in your
patch
> and move async_tx under lib/ for now, but at some point I would like
to
> investigate the potential synergies with crypto/.
> 

Herbert can I move async_tx under crypto since the engines I am working
with have support for algorithms like CRC32C and Galois Field Multiply
(raid6 p+q)?
