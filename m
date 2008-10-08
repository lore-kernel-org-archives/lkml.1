Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbYJHC61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbYJHC61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 22:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754886AbYJHC6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 22:58:16 -0400
Received: from mga14.intel.com ([143.182.124.37]:42932 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbYJHC6P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 22:58:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,376,1220252400"; 
   d="scan'208";a="56541993"
From: "Zhao, Yu" <yu.zhao@intel.com>
To: Matthew Wilcox <matthew@wil.cx>, Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Alex Chiang <achiang@hp.com>, Roland Dreier <rdreier@cisco.com>,
       Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Date: Wed, 8 Oct 2008 10:56:18 +0800
Subject: RE: [PATCH 3/6 v3] PCI: support ARI capability
Thread-Topic: [PATCH 3/6 v3] PCI: support ARI capability
Thread-Index: AckkqnQBvJygFt8TQiiXb//IbDgBbwERrJeg
Message-ID: <D8078B8B3B09934AA9F8F2D5FB3F28CE08A3D243B6@pdsmsx502.ccr.corp.intel.com>
References: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5F3@pdsmsx502.ccr.corp.intel.com>
 <200810020903.16385.jbarnes@virtuousgeek.org>
 <20081002161701.GO13822@parisc-linux.org>
In-Reply-To: <20081002161701.GO13822@parisc-linux.org>
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

On Friday, October 03, 2008 12:17 AM, Matthew Wilcox wrote:
>On Thu, Oct 02, 2008 at 09:03:15AM -0700, Jesse Barnes wrote:
>> Maybe we should be consistent with the other APIs and call it pci_enable_ari
>> (like we do for wake & msi).  Looks pretty good otherwise.
>
>Those APIs are for drivers ... this is internal.  I don't have any
>objection of my own, though I agree with Alex's remark that the printk
>is unnecessary and just adds clutter to the boot process.

Will rename the function to pci_enable_ari, and remove the printk.

Thanks.

>
>--
>Matthew Wilcox                          Intel Open Source Technology Centre
>"Bill, look, we understand that you're interested in selling us this
>operating system, but compare it to ours.  We can't possibly take such
>a retrograde step."
>--
>To unsubscribe from this list: send the line "unsubscribe kvm" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
