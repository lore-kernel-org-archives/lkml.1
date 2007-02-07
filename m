Return-Path: <linux-kernel-owner+w=401wt.eu-S965643AbXBGF7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965643AbXBGF7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 00:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965644AbXBGF7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 00:59:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:2970 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965643AbXBGF7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 00:59:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,292,1167638400"; 
   d="scan'208"; a="43782949:sNHT26366940"
Message-ID: <45C96AC1.4030301@linux.intel.com>
Date: Wed, 07 Feb 2007 06:59:29 +0100
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Marc Donner <donner@dbd-breitband.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: cpu load balancing problem on smp
References: <200702061832.17771.donner@dbd-breitband.de> <200702061941.32907.donner@dbd-breitband.de> <45C8CC2A.90403@linux.intel.com> <200702070049.51536.donner@dbd-breitband.de>
In-Reply-To: <200702070049.51536.donner@dbd-breitband.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Donner wrote:
> 501:     215717     209388     209430     202514   PCI-MSI-edge      eth10
> 502:        927       1019       1053        888   PCI-MSI-edge      eth11

this is odd, this is not an irq distribution that irqbalance should 
give you
1
> NMI:        451         39         42         46
> LOC:     170899     170864     170846     170788
> ERR:          0
> 
> top output:
> 
> top - 01:45:32 up 16 min,  2 users,  load average: 1.04, 0.92, 0.50
> Tasks:  81 total,   3 running,  78 sleeping,   0 stopped,   0 zombie
> Cpu0  :  0.0% us,  0.0% sy,  0.0% ni,  0.0% id,  0.0% wa,  0.0% hi, 100.0% si
>
and this doesn't match the irq output...
sounds as if something has a real bug; can you send an lsmod ? maybe 
some driver keeps doing si's
