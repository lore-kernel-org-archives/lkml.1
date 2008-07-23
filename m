Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbYGWBqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbYGWBqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 21:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbYGWBqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 21:46:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:56690 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbYGWBqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 21:46:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,235,1215414000"; 
   d="scan'208";a="318098909"
Subject: Re: [PATCH] x86,pci: dmi check for mackpro 2.2 mmconf
From: Shaohua Li <shaohua.li@intel.com>
To: Jack Howarth <howarth@bromo.msbb.uc.edu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080723014137.GA12895@bromo.msbb.uc.edu>
References: <20080722233722.GA12247@bromo.msbb.uc.edu>
	 <200807221723.04654.jbarnes@virtuousgeek.org>
	 <20080723010058.GA12662@bromo.msbb.uc.edu>
	 <200807221832.21167.jbarnes@virtuousgeek.org>
	 <20080723014137.GA12895@bromo.msbb.uc.edu>
Content-Type: text/plain
Date: Wed, 23 Jul 2008 09:54:16 +0800
Message-Id: <1216778056.30000.2.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-22 at 21:41 -0400, Jack Howarth wrote:
> Jesse,
>    The file /sys/module/pcie_aspm/parameters/policy
> shows...
> 
> [default] performance powersave 
you can observe a sysfs file 'link_state' under a pci root port.
/sys/device/...pcixxx/power/link_state.
if there is no such file for the port, then aspm is disabled for the
port.

> Reading the original patch, I don't quite see how it would
> show the aspm as disabled. I would think the current ASPM
> fix patch should be modified to output a kernel message that
> ASPM is being disabled because of pre-1.1 PCIe devices
> when it does that (assuming it is disabling across the
> board and not just for a specific device on the bus).
ok, I'll do this.

Thanks,
SHaohua

