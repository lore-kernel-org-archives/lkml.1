Return-Path: <linux-kernel-owner+w=401wt.eu-S932121AbZINPCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121AbZINPCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 11:02:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932076AbZINPB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 11:01:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:17748 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932078AbZINPB5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 11:01:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,383,1249282800"; 
   d="scan'208";a="448323595"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Mon, 14 Sep 2009 16:01:58 +0100
Subject: RE: [PATCH 28/29] dmaengine: kill tx_list
Thread-Topic: [PATCH 28/29] dmaengine: kill tx_list
Thread-Index: AcotCAFR28veFN5WShiRcdNSjWa5gwIREPMQ
Message-ID: <129600E5E5FB004392DDC3FB599660D7B554819A@irsmsx504.ger.corp.intel.com>
References: <20090904022733.32667.77626.stgit@dwillia2-linux.ch.intel.com>
 <20090904023252.32667.51136.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090904023252.32667.51136.stgit@dwillia2-linux.ch.intel.com>
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
> The tx_list attribute of struct dma_async_tx_descriptor is common to
> most, but not all dma driver implementations.  None of the upper level
> code (dmaengine/async_tx) uses it, so allow drivers to implement it
> locally if they need it.  This saves sizeof(struct list_head) bytes for
> drivers that do not manage descriptors with a linked list (e.g.: ioatdma
> v2,3).
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>