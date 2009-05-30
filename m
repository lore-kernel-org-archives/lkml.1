Return-Path: <linux-kernel-owner+w=401wt.eu-S1759966AbZE3ND5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966AbZE3ND5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 09:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757864AbZE3NDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 09:03:49 -0400
Received: from smtp.citrix.com ([66.165.176.89]:24099 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182AbZE3NDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 09:03:49 -0400
X-IronPort-AV: E=Sophos;i="4.41,276,1241409600"; 
   d="scan'208";a="4473759"
Subject: Re: [PATCH 6/9] swiotlb: use dma_to_phys and phys_to_dma
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: <linux-kernel@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Olaf Kirch <okir@suse.de>, Greg KH <gregkh@suse.de>,
       Tony Luck <tony.luck@intel.com>,
       Becky Bruce <beckyb@kernel.crashing.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Kumar Gala <galak@kernel.crashing.org>, <x86@kernel.org>,
       <linux-ia64@vger.kernel.org>, <linuxppc-dev@ozlabs.org>
In-Reply-To: <4A204EFC.501@goop.org>
References: <1243586643-5554-1-git-send-email-ian.campbell@citrix.com>
	 <1243586643-5554-7-git-send-email-ian.campbell@citrix.com>
	 <4A204EFC.501@goop.org>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Sat, 30 May 2009 14:02:58 +0100
Message-ID: <1243688578.4399.67.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-29 at 14:09 -0700, Jeremy Fitzhardinge wrote:
> Ian Campbell wrote:
> >  void * __weak swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t address)
> >   
> 
> Does this need to be weak too?

It's was wanted by PowerPC to support highmem, that's what patch 8/9
tries to address in an arch-independent way.

Ian.


