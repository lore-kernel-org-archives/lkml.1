Return-Path: <linux-kernel-owner+w=401wt.eu-S1759166AbZBLQhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166AbZBLQhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 11:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756181AbZBLQhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 11:37:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:46133 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756102AbZBLQhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 11:37:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,197,1233561600"; 
   d="scan'208";a="386277829"
Subject: Re: [ipw3945-devel] iwl breaking on suspend/resume,	regression
	from 2.6.29-rc3
From: reinette chatre <reinette.chatre@intel.com>
To: Norbert Preining <preining@logic.at>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20090212130520.GA19991@gamma.logic.tuwien.ac.at>
References: <20090212130520.GA19991@gamma.logic.tuwien.ac.at>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 08:41:19 -0800
Message-Id: <1234456879.23593.131.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 05:05 -0800, Norbert Preining wrote:
> Hi all,
> 
> since I have switched to 2.6.29-rc4 (from rc3) suspending and resuming
> takes MUCH longer due to iwlagn doing something strange:
> [ 6921.233094] iwlagn: Could not load the INST uCode section
> [ 6921.233097] iwlagn: Unable to set up bootstrap uCode: -110
> [ 6926.233096] iwlagn: Could not load the INST uCode section
> [ 6926.233098] iwlagn: Unable to set up bootstrap uCode: -110
> [ 6931.233136] iwlagn: Could not load the INST uCode section
> [ 6931.233138] iwlagn: Unable to set up bootstrap uCode: -110
> [ 6936.233096] iwlagn: Could not load the INST uCode section
> [ 6936.233098] iwlagn: Unable to set up bootstrap uCode: -110
> [ 6941.233094] iwlagn: Could not load the INST uCode section
> [ 6941.233096] iwlagn: Unable to set up bootstrap uCode: -110
> [ 6941.241144] iwlagn: Unable to initialize device after 5 attempts.
> 
> Here is what I have in the laptop:
> [   13.028298] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
> [   13.028366] iwlagn: Copyright(c) 2003-2008 Intel Corporation
> [   13.028496] iwlagn 0000:06:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [   13.028580] iwlagn 0000:06:00.0: setting latency timer to 64
> [   13.028625] iwlagn: Detected Intel Wireless WiFi Link 5100AGN REV=0x54
> [   13.050694] iwlagn: Tunable channels: 13 802.11bg, 24 802.11a channels
> [   13.051006] iwlagn 0000:06:00.0: PCI INT A disabled
> 

Could you please try
http://marc.info/?l=linux-wireless&m=123429595818495&w=2 ?

Thanks

Reinette

