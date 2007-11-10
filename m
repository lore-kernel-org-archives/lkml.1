Return-Path: <linux-kernel-owner+w=401wt.eu-S1763371AbXKJBSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763371AbXKJBSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 20:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbXKJBSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 20:18:05 -0500
Received: from mga01.intel.com ([192.55.52.88]:2128 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754747AbXKJBSE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 20:18:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,397,1188802800"; 
   d="scan'208";a="376689952"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: 
Date: Fri, 9 Nov 2007 17:18:01 -0800
Message-ID: <617E1C2C70743745A92448908E030B2A02E9A31C@scsmsx411.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Index: AcgjN4lTkJ0M9AaITyWTzL8DQQGf5g==
From: "Luck, Tony" <tony.luck@intel.com>
To: "LKML" <linux-kernel@vger.kernel.org>
Cc: <dada1@cosmosbay.com>
X-OriginalArrivalTime: 10 Nov 2007 01:18:02.0600 (UTC) FILETIME=[8A07CE80:01C82337]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just pulled latest git tree from Linus and a few ia64 configurations
(anything with CONFIG_NUMA=y) won't build.

The offending commit appears to be:

    230140cffa7feae90ad50bf259db1fa07674f3a7

Here's the error messages from the compiler:

  CC [M]  drivers/infiniband/core/cma.o
In file included from include/net/tcp.h:35,
                 from drivers/infiniband/core/cma.c:40:
include/net/inet_hashtables.h: In function `inet_ehash_locks_alloc':
include/net/inet_hashtables.h:165: error: implicit declaration of
function `vmalloc'
include/net/inet_hashtables.h:165: warning: assignment makes pointer
from integer without a cast
include/net/inet_hashtables.h: In function `inet_ehash_locks_free':
include/net/inet_hashtables.h:186: error: implicit declaration of
function `vfree'
make[3]: *** [drivers/infiniband/core/cma.o] Error 1


-Tony
