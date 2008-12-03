Return-Path: <linux-kernel-owner+w=401wt.eu-S1752119AbYLCKSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbYLCKSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 05:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbYLCKR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 05:17:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:63216 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbYLCKR5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 05:17:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,708,1220252400"; 
   d="scan'208";a="411014177"
From: "Han, Weidong" <weidong.han@intel.com>
To: "'Joerg Roedel'" <joerg.roedel@amd.com>,
       "'Ingo Molnar'" <mingo@redhat.com>, "'Avi Kivity'" <avi@redhat.com>,
       "'David Woodhouse'" <dwmw2@infradead.org>,
       "'Greg Kroah-Hartman'" <gregkh@suse.de>,
       "'Alexander Graf'" <agraf@suse.de>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>
Date: Wed, 3 Dec 2008 18:17:42 +0800
Subject: RE: [PATCH 0/12] Factor VT-d KVM functions into a generic API (with
 multiple device assignment support)
Thread-Topic: [PATCH 0/12] Factor VT-d KVM functions into a generic API
 (with multiple device assignment support)
Thread-Index: AclUfjsNMbd7jPEiTUy0rYmVBnPqjQAsGKpQ
Message-ID: <715D42877B251141A38726ABF5CABF2C018BF4D1FC@pdsmsx503.ccr.corp.intel.com>
References: <1228222883-17207-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1228222883-17207-1-git-send-email-joerg.roedel@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> Hi,
> 
> this patch series makes the current KVM device passthrough code
> generic 
> enough so that other IOMMU implementation can also plug into this
> code. 
> It works by factoring the functions Vt-d code exports to KVM into a
> generic interface which allows different backends.
> 
> This is the second version of the patchset. The most important change
> to 
> the previous version is that this patchset was rebased to the improved
> API from Han Weidong which supports multiple devices per IOMMU domain.
> 
> For completeness, this series also includes the patches from Han with
> some cleanups. So this patchset can be applied on current avi/master
> tree.
> 
> For testing this code can also be pulled against avi/master tree from
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git
> iommu-api 
> 
> This a basic implementation of a generic interface. It can and should
> be improved later to support more types of hardware IOMMUs then VT-d
> and 
> AMD IOMMU.
> 
> Since I have no VT-d hardware available these patches are only compile
> tested for now.
> 
> Please review, comment and test these patches.

Tried this patchset on avi/master tree, VT-d works. Your generic API approach is ok for me. But the multiple devices assignment patches (here patch 01 and 02) needs some improvement, and they are too big to review. I have split them into a serial small patches, and sent out for review in another mail thread. After my multiple device assignment patchset is accepted, I think you can easily rebase your generic patchset on it.

Regards,
Weidong

