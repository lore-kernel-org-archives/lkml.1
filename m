Return-Path: <linux-kernel-owner+w=401wt.eu-S1756229AbZLXI7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbZLXI7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 03:59:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbZLXI7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 03:59:13 -0500
Received: from mga03.intel.com ([143.182.124.21]:20269 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754693AbZLXI7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 03:59:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="226327412"
Subject: Re: [PATCH 3/5 -v2] acpi, apei, HEST table parsing
From: Huang Ying <ying.huang@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       ACPI mailing list <linux-acpi@vger.kernel.org>
In-Reply-To: <20091218184443.GD1470@ucw.cz>
References: <1260429419.15264.395.camel@yhuang-dev.sh.intel.com>
	 <20091218184443.GD1470@ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Dec 2009 16:59:10 +0800
Message-ID: <1261645150.6908.28.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-12-19 at 02:44 +0800, Pavel Machek wrote: 
> On Thu 2009-12-10 15:16:59, Huang Ying wrote:
> > HEST describes error sources in detail; communicating operational
> > parameters (i.e. severity levels, masking bits, and threshold values)
> > to OS as necessary. It also allows the platform to report error
> > sources for which OS would typically not implement support (for
> > example, chipset-specific error registers).
> > 
> > HEST information may be needed by other subsystems. For example, HEST
> > PCIE AER error source information describes whether a PCIE root port
> > works in "firmware first" mode, this is needed by general PCIE AER
> > error subsystem. So a public HEST tabling parsing interface is
> > provided.
> 
> Perhaps you can remove unused hest_exit()?

OK. I will remove it.

Best Regards,
Huang Ying


