Return-Path: <linux-kernel-owner+w=401wt.eu-S1755694AbZINPAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694AbZINPAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 11:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755652AbZINPAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 11:00:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:26434 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660AbZINPAu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 11:00:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,383,1249282800"; 
   d="scan'208";a="448323121"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Mon, 14 Sep 2009 16:00:52 +0100
Subject: RE: [PATCH 22/29] net_dma: poll for a descriptor after allocation
 failure
Thread-Topic: [PATCH 22/29] net_dma: poll for a descriptor after allocation
 failure
Thread-Index: AcotB/C/dJXxVKxkSvmMSbkttSpYtwIRC0sw
Message-ID: <129600E5E5FB004392DDC3FB599660D7B5548195@irsmsx504.ger.corp.intel.com>
References: <20090904022733.32667.77626.stgit@dwillia2-linux.ch.intel.com>
 <20090904023221.32667.70000.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090904023221.32667.70000.stgit@dwillia2-linux.ch.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Williams, Dan J wrote:
> Handle descriptor allocation failures by polling for a descriptor.  The
> driver will force forward progress when polled.  In the best case this
> polling interval will be the time it takes for one dma memcpy
> transaction to complete.  In the worst case, channel hang, we will need
> to wait 100ms for the cleanup watchdog to fire (ioatdma driver).
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>