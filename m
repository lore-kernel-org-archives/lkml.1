Return-Path: <linux-kernel-owner+w=401wt.eu-S1752749AbYKGBwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbYKGBwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 20:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750757AbYKGBwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 20:52:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:6714 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbYKGBwc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 20:52:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,560,1220252400"; 
   d="scan'208";a="636517245"
From: "Dong, Eddie" <eddie.dong@intel.com>
To: Anthony Liguori <anthony@codemonkey.ws>, Matthew Wilcox <matthew@wil.cx>
CC: "Fischer, Anna" <anna.fischer@hp.com>, Greg KH <greg@kroah.com>,
       H L <swdevyid@yahoo.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "Chiang, Alexander" <achiang@hp.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>, "Dong, Eddie" <eddie.dong@intel.com>
Date: Fri, 7 Nov 2008 09:52:28 +0800
Subject: RE: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
Thread-Topic: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
Thread-Index: AclAYHlBPQQjKq7nRTWqavkSm5qUDwAGh47w
Message-ID: <9832F13BD22FB94A829F798DA4A82805018BF38DAB@pdsmsx503.ccr.corp.intel.com>
References: <20081106154351.GA30459@kroah.com>
 <894107.30288.qm@web45108.mail.sp1.yahoo.com>
 <20081106164919.GA4099@kroah.com>
 <0199E0D51A61344794750DC57738F58E5E26F996C4@GVW1118EXC.americas.hpqcorp.net>
 <20081106183630.GD11773@parisc-linux.org> <491371F0.7020805@codemonkey.ws>
In-Reply-To: <491371F0.7020805@codemonkey.ws>
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


> What we would rather do in KVM, is have the VFs appear in
> the host as standard network devices.  We would then like
> to back our existing PV driver to this VF directly
> bypassing the host networking stack.  A key feature here
> is being able to fill the VF's receive queue with guest
> memory instead of host kernel memory so that you can get
> zero-copy  
> receive traffic.  This will perform just as well as doing
> passthrough (at least) and avoid all that ugliness of
> dealing with SR-IOV in the guest. 
> 

Anthony:
	This is already addressed by VMDq solution(or so called netchannel2), right? Qing He is debugging the KVM side patch and pretty much close to end.

	For this single purpose, we don't need SR-IOV. BTW at least Intel SR-IOV NIC also supports VMDq, so you can achieve this by simply use "native" VMDq enabled driver here, plus the work we are debugging now.

Thx, eddie
