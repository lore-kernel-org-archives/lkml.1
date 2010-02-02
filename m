Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab0BBRu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 12:50:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:6655 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869Ab0BBRux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 12:50:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,392,1262592000"; 
   d="scan'208";a="592516290"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH 6/6] xen/hybrid: Enable grant table and xenbus
Date: Wed, 3 Feb 2010 01:46:29 +0800
User-Agent: KMail/1.12.2 (Linux/2.6.31-17-generic; KDE/4.3.2; x86_64; ; )
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       "xen-devel" <xen-devel@lists.xensource.com>,
       linux-kernel@vger.kernel.org
References: <1265098747-10117-1-git-send-email-sheng@linux.intel.com> <1265098747-10117-7-git-send-email-sheng@linux.intel.com> <20100202170306.GA32305@phenom.dumpdata.com>
In-Reply-To: <20100202170306.GA32305@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002030146.29966.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 February 2010 01:03:06 Konrad Rzeszutek Wilk wrote:
> > +#define GNTTAB_START	    0xfbfe0000ul
> > +#define GNTTAB_SIZE	    0x20000ul
> 
> Is it possible that there would be a PCI device that would be
> passed in the guest that would conflict with the above mentioned
> E820 region?
> 
I would change them to a dedicated PCI MMIO address in the next version. 
Thanks.

-- 
regards
Yang, Sheng
