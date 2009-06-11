Return-Path: <linux-kernel-owner+w=401wt.eu-S1757365AbZFKS5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbZFKS5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755688AbZFKS47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:56:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:3208 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754997AbZFKS46 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:56:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,203,1243839600"; 
   d="scan'208";a="698575375"
Date: Thu, 11 Jun 2009 11:56:13 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/3] pci: Provide Multiple Error Received and no error
 source id support on AER
Message-ID: <20090611115613.40beb30f@jbarnes-g45>
In-Reply-To: <1241504532.27664.45.camel@ymzhang>
References: <1241504532.27664.45.camel@ymzhang>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 May 2009 14:22:12 +0800
"Zhang, Yanmin" <yanmin_zhang@linux.intel.com> wrote:

> Based on PCI Express AER specs, a root port might receive multiple
> TLP errors while it could only save a correctable error source id
> and an uncorrectable error source id at the same time. In addition,
> some root port hardware might be unable to provide a correct source
> id, i.e., the source id provided by root port might be equal to 0.
> 
> The patchset implements the support in kernel by searching the device
> tree under the root port.
> 
> Patch 1 changes parameter cb of function pci_walk_bus to return a
> value. When cb return non-zero, pci_walk_bus stops more searching on
> the device tree.
> 
> ﻿﻿﻿Signed-off-by: ﻿Zhang Yanmin <yanmin.zhang@linux.intel.com>

Yanmin, can you resend these against my linux-next tree later today or
tomorrow?  I'll be rebasing to get the latest bits there, and there are
some conflicts (would also be good to get some additional review; I
definitely like this feature though).

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
