Return-Path: <linux-kernel-owner+w=401wt.eu-S2993448AbXEBQRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993448AbXEBQRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 12:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993447AbXEBQRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 12:17:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:49717 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993450AbXEBQRO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 12:17:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,480,1170662400"; 
   d="scan'208";a="82703396"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 00/16] raid acceleration and asynchronous offload api for 2.6.22
Date: Wed, 2 May 2007 09:17:13 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E5201CA8E4D@azsmsx413.amr.corp.intel.com>
In-Reply-To: <Pine.LNX.4.64.0705021154410.25382@p34.internal.lan>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 00/16] raid acceleration and asynchronous offload api for 2.6.22
Thread-Index: AceM0mZiusGRqaJ0Qr+U+kHHBBWcfgAAL02g
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>, <neilb@suse.de>,
       <akpm@linux-foundation.org>,
       "Leech, Christopher" <christopher.leech@intel.com>,
       <linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>
X-OriginalArrivalTime: 02 May 2007 16:17:13.0621 (UTC) FILETIME=[58084C50:01C78CD5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Justin Piszcz [mailto:jpiszcz@lucidpixels.com]
> I have not been following this closely, must you have an
> CONFIG_INTEL_IOP_ADMA piece of hardware and/or chipset to use this
> feature or can regular desktop users take hold of it as well?
> 
Currently this feature is available on the iop series of processors,
e.g. http://www.intel.com/design/iio/iop348.htm

And there is a driver in the works to support the 440spe platform
(http://marc.info/?l=linux-raid&m=117400143317440&w=2)

Desktops currently take advantage of architecture specific SIMD
instructions to accelerate xor calculations.

> Justin.

Dan
