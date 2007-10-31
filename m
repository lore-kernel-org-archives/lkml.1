Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbXJaBGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbXJaBGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 21:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755523AbXJaBEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 21:04:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:12037 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523AbXJaBEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 21:04:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,349,1188802800"; 
   d="scan'208";a="363834142"
Subject: Re: iwl3945 in 2.6.24-rc1 dies under load
From: Zhu Yi <yi.zhu@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-wireless@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>,
       ipw3945-devel@lists.sourceforge.net
In-Reply-To: <20071031005202.GA1534@elf.ucw.cz>
References: <20071031005202.GA1534@elf.ucw.cz>
Content-Type: text/plain
Organization: Intel Corp.
Date: Wed, 31 Oct 2007 08:54:58 +0800
Message-Id: <1193792098.9704.16.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-10-31 at 01:52 +0100, Pavel Machek wrote:
> tcpspray -n 1 -b 10000000 10.0.0.2
> 
> Oct 31 01:42:56 amd kernel: iwl3945: Microcode SW error detected.
> Restarting 0x82000008.
> Oct 31 01:42:56 amd kernel: iwl3945: Error Reply type 0x00000005 cmd
> REPLY_TX (0x1C) seq 0x02C7 ser 0x0000004B
> Oct 31 01:42:58 amd kernel: iwl3945: Can't stop Rx DMA.

Please attach the dmesg with module param debug=0x43fff (make sure
CONFIG_IWLWIFI_DEBUG is selected). This will dump the firmware event log
for debug.

Thanks,
-yi
