Return-Path: <linux-kernel-owner+w=401wt.eu-S934259AbXGWTRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934259AbXGWTRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 15:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764467AbXGWTRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 15:17:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:32664 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761572AbXGWTRc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 15:17:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,572,1175497200"; 
   d="scan'208";a="253717029"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: drivers/dma/ioatdma.c - address of '__this_module' will always evaluate as 'true' , warning
Date: Mon, 23 Jul 2007 12:17:30 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C02BBD9F4@orsmsx418.amr.corp.intel.com>
In-Reply-To: <46A4D8F1.2000703@googlemail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: drivers/dma/ioatdma.c - address of '__this_module' will always evaluate as 'true' , warning
Thread-Index: AcfNR/EnCKRznuAlTSyNP28bx4ELsgAE2a1A
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Gabriel C" <nix.or.die@googlemail.com>
Cc: "lkml" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 23 Jul 2007 19:17:30.0615 (UTC) FILETIME=[1D561870:01C7CD5E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C [mailto:nix.or.die@googlemail.com] 
>Nelson, Shannon wrote:
>> Gabriel C [mailto:nix.or.die@googlemail.com] 
>>> Hi,
>>>
>>> I got this warning on current git using gcc 4.2.1 :
>>>
>>> ...
>>>
>>> drivers/dma/ioatdma.c: In function 'ioat_init_module':
>>> drivers/dma/ioatdma.c:816: warning: the address of 
>>> '__this_module' will always evaluate as 'true'
>> 
>> Can you forward a copy of your .config?
>
>Sure , config attached.

Hmmm - never mind.  It looks like the gcc folks are getting picky with
some expressions.  See many other similar threads.

sln
--
======================================================================
Mr. Shannon Nelson                 LAN Access Division, Intel Corp.
Shannon.Nelson@intel.com                I don't speak for Intel
(503) 712-7659                    Parents can't afford to be squeamish.
