Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753420AbYLRCj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbYLRCj0 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 21:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750957AbYLRCjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 21:39:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:59129 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbYLRCjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 21:39:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,241,1228118400"; 
   d="scan'208";a="650722225"
Message-ID: <4949B7CE.5010704@intel.com>
Date: Thu, 18 Dec 2008 10:39:10 +0800
From: "Zhao, Yu" <yu.zhao@intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Greg KH <greg@kroah.com>, "Rose, Gregory V" <gregory.v.rose@intel.com>,
        Jike Song <albcamus@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "achiang@hp.com" <achiang@hp.com>,
        "bjorn.helgaas@hp.com" <bjorn.helgaas@hp.com>,
        "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "matthew@wil.cx" <matthew@wil.cx>,
        "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
        "rdreier@cisco.com" <rdreier@cisco.com>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 0/13 v7] PCI: Linux kernel SR-IOV support
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com> <200812171142.56170.jbarnes@virtuousgeek.org> <20081217195143.GA25211@kroah.com> <200812171207.34396.jbarnes@virtuousgeek.org>
In-Reply-To: <200812171207.34396.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Wednesday, December 17, 2008 11:51 am Greg KH wrote:
>> On Wed, Dec 17, 2008 at 11:42:54AM -0800, Jesse Barnes wrote:
>>> I really don't want the SR-IOV stuff to sit out another merge cycle
>>> though... Arg.
>> Why, is there some rush to get it in?  As there is no in-kernel users of
>> it, I don't see the problem with postponing it until someone actually
>> needs it.
> 
> Well it *does* make development of SR-IOV drivers that much harder.  As you 
> know, out of tree development is a pain.  OTOH if any changes end up being 
> required, they can be done before the code is merged.

Yes, people write to me asking for the SR-IOV patch or update everyday 
-- I guess they don't want to let their competitors know they are 
working on it so they can't bring their questions up on the mailing list.

And I personally also have dozen of other patches related to PCI and KVM 
subsystems which depend on the SR-IOV change.

> Anyway, hopefully we won't have to worry about it because some driver will 
> come along soon that uses Yu's code. :)  If not, Yu might have to maintain a 
> separate git tree or something until the drivers are ready to be merged.
