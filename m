Return-Path: <linux-kernel-owner+w=401wt.eu-S970207AbXFHWSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970207AbXFHWSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759732AbXFHWSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:18:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:27044 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbXFHWSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:18:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,401,1175497200"; 
   d="scan'208";a="94940763"
Message-ID: <4669D55C.6040803@linux.intel.com>
Date: Fri, 08 Jun 2007 15:17:00 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Andreas Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, muli@il.ibm.com, asit.k.mallick@intel.com,
       suresh.b.siddha@intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
References: <20070606185658.138237000@askeshav-devel.jf.intel.com>	<20070606190042.510643000@askeshav-devel.jf.intel.com>	<20070607162726.2236a296.akpm@linux-foundation.org>	<20070608182156.GA24865@linux-os.sc.intel.com>	<20070608120107.245eba96.akpm@linux-foundation.org>	<6901450.1181335390183.SLOX.WebMail.wwwrun@imap-dhs.suse.de>	<20070608212054.GB641@linux-os.sc.intel.com> <20070608144207.07341ee7.akpm@linux-foundation.org>
In-Reply-To: <20070608144207.07341ee7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Put much effort into removing the GFP_ATOMIC and using GFP_NOIO instead:
> there's your problem right there.
> 
> If for some reason you really can't do that (and a requirement for
> allocation-in-interrupt is the only valid reason, really)

and that's the case here; IO gets submitted from IRQ handlers (both 
network and block).......
