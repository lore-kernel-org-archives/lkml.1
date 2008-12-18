Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753460AbYLRC05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbYLRC05 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 21:26:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbYLRC0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 21:26:44 -0500
Received: from mga11.intel.com ([192.55.52.93]:15247 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbYLRC0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 21:26:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,241,1228118400"; 
   d="scan'208";a="415425246"
Message-ID: <4949B4E0.2010409@intel.com>
Date: Thu, 18 Dec 2008 10:26:40 +0800
From: "Zhao, Yu" <yu.zhao@intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "achiang@hp.com" <achiang@hp.com>,
        "bjorn.helgaas@hp.com" <bjorn.helgaas@hp.com>,
        "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
        "greg@kroah.com" <greg@kroah.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
        "rdreier@cisco.com" <rdreier@cisco.com>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 0/13 v7] PCI: Linux kernel SR-IOV support
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com> <200812161523.55238.jbarnes@virtuousgeek.org> <20081217141542.GB19967@parisc-linux.org>
In-Reply-To: <20081217141542.GB19967@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Tue, Dec 16, 2008 at 03:23:53PM -0800, Jesse Barnes wrote:
>> I applied 1-9 to my linux-next branch; and at least patch #10 needs a respin, 
> 
> I still object to #2.  We should have the flexibility to have 'struct
> resource's that are not in this array in the pci_dev.  I would like to
> see the SR-IOV resources _not_ in this array (and indeed, I'd like to
> see PCI bridges keep their producer resources somewhere other than in
> this array).  I accept that there are still some problems with this, but

I understand your concern, and agree that using the array as resource 
manager is not the best way. But for now it's not possible as you know. 
We need a better resource manager for PCI subsystem to manage the 
various resources (traditional, device specific, bus related), which is 
another independent work from SR-IOV change.

> patch #2 moves us further from being able to achieve this goal, not
> closer.

The array is obvious straightforward and can be easily replaced with a 
more advanced resource manager in the future. So I don't think we going 
  further from or closer to the goal.

Thanks,
Yu

