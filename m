Return-Path: <linux-kernel-owner+w=401wt.eu-S1764955AbXGVUtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764955AbXGVUtt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 16:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763509AbXGVUtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 16:49:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:17419 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763213AbXGVUtm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 16:49:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,569,1175497200"; 
   d="scan'208";a="269180131"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: DMA Engine vs. DMA Transfer API
Date: Sun, 22 Jul 2007 13:49:40 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C02B81E50@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20070721084233.GE21334@clifford.at>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: DMA Engine vs. DMA Transfer API
Thread-Index: AcfLcquZISPqHOltRsqYRkzk71HTsABLdQYg
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Clifford Wolf" <clifford@clifford.at>,
       "lkml" <linux-kernel@vger.kernel.org>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>
X-OriginalArrivalTime: 22 Jul 2007 20:49:41.0192 (UTC) FILETIME=[D3676C80:01C7CCA1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Clifford Wolf [mailto:clifford@clifford.at] 
>
>Hi Shannon, hi lkml,

Hi Clifford,

>I'm writing a driver for the built-in DMA controller of the Freescale
>MPC8349E PowerPC based microcontroller. Unfortunately the DMA-Engine
>API seams to be the totally wrong thing for that since this 
>DMA controller
>has many features which are not available thru dmaengine 
>[...]

This has been one of the biggest issues with the original dmaengine
interface - it didn't play well with others.  Since then a few folks
have taken a couple shots at it, but Dan Williams recently has done it
best in his changes aimed at rolling in his RAID accelleration engine.
Most of what you are looking for is already available - see the recent
changes in the dmaengine that allow for multiple DMA clients, multiple
DMA engines, and a method for selecting DMA services based upon the
capabilities needed.

If these changes still don't quite fit your need, let us know and we can
probably help you work it out.

Now, you go back to your vacation and I'll go back to my quiet Sunday
afternoon.

sln
--
======================================================================
Mr. Shannon Nelson                 LAN Access Division, Intel Corp.
Shannon.Nelson@intel.com                I don't speak for Intel
(503) 712-7659                    Parents can't afford to be squeamish.
