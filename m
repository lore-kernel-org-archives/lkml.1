Return-Path: <linux-kernel-owner+w=401wt.eu-S1759545AbYFIWWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545AbYFIWWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753779AbYFIWWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:22:06 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:36316 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbYFIWWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:22:05 -0400
Date: Mon, 9 Jun 2008 16:22:02 -0600
From: Alex Chiang <achiang@hp.com>
To: jbarnes@virtuousgeek.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Wilcox <matthew@wil.cx>, kristen.c.accardi@intel.com,
       greg@kroah.com, lenb@kernel.org, pbadari@us.ibm.com,
       linux-pci@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3, v15] PCI, ACPI: Physical PCI slot objects
Message-ID: <20080609222202.GB16588@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, jbarnes@virtuousgeek.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Matthew Wilcox <matthew@wil.cx>, kristen.c.accardi@intel.com,
	greg@kroah.com, lenb@kernel.org, pbadari@us.ibm.com,
	linux-pci@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew, Jesse,

This is v15 of the physical PCI slot series.

v14 -> v15

	- reintroduce pci-hotplug-core-add-check-of-duplicate-slot-name
	  a86161b3134465f072d965ca7508ec9c1e2e52c7

	- fold kobject-Export-kobject_rename-for-pci_hotplug_core
	  into patch 3/3 to reduce commit log noise (as suggested
	  by akpm). The -mm file name is: 
	  	acpi-pci-slot-detection-driver-fix.patch

I tried to edit the commit-logs as best I could for proper
attribution, copying what I *think* is akpm's style. Please let
me know if I messed up here.

This series is based on the most recent linux-next tree, and
thanks to BenH's Acked-by, I think we're finally ready for Linus'
tree (pending one final ACK from Kenji-san).

Thanks,

/ac

