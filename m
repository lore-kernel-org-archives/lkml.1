Return-Path: <linux-kernel-owner+w=401wt.eu-S1759503AbXFITbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503AbXFITbh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 15:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758163AbXFITba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 15:31:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:22116 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758139AbXFITb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 15:31:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,403,1175497200"; 
   d="scan'208";a="237397358"
Message-ID: <466B0005.30006@intel.com>
Date: Sat, 09 Jun 2007 12:31:17 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: grundler@parisc-linux.org, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, gregkh@suse.de
Subject: Re: [PATCH 1/2] [RFC] PCI: read revision ID by default
References: <20070608224630.31777.17807.stgit@localhost.localdomain>	<20070609065953.GA1747@colo.lackof.org> <20070609.010249.77260306.davem@davemloft.net>
In-Reply-To: <20070609.010249.77260306.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Grant Grundler <grundler@parisc-linux.org>
> Date: Sat, 9 Jun 2007 00:59:53 -0600
> 
>> On Fri, Jun 08, 2007 at 03:46:30PM -0700, Auke Kok wrote:
>>> Currently there are 97 occurrences where drivers need the pci
>>> revision ID. We can do this once for all devices. Even the pci
>>> subsystem needs the revision several times for quirks. The extra
>>> u8 member pads out nicely in the pci_dev struct.
>> Good idea. I always wondered why we read the invariants so often
>> in the code.
> 
> BTW, if you add code like this, you also have to add the
> appropriate code to do this for all the platforms that probe
> the PCI bus using a firmware device tree like sparc64
> and powerpc do.

yes absolutely, I'll try to see if I can come up with that. Also, I'll add 
reading the class part at the same time since that just makes sense.

Auke
