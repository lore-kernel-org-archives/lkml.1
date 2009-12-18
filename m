Return-Path: <linux-kernel-owner+w=401wt.eu-S1752423AbZLRI7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbZLRI7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 03:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZLRI7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 03:59:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:43261 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbZLRI7V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 03:59:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,415,1257148800"; 
   d="scan'208";a="757379161"
From: "Cui, Dexuan" <dexuan.cui@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Date: Fri, 18 Dec 2009 16:57:55 +0800
Subject: RE: linux-next: Tree for December 17 (pci/quirks)
Thread-Topic: linux-next: Tree for December 17 (pci/quirks)
Thread-Index: Acp/S2i4q4fZiFpAR2OPP1T6qFDqUQAMb+3w
Message-ID: <ED3036A092A28F4C91B0B4360DD128EA3032134C@shzsmsx502.ccr.corp.intel.com>
References: <20091217165840.e11fc719.sfr@canb.auug.org.au>
	<20091217095506.64f0a43f.randy.dunlap@oracle.com>
 <20091217105900.1d8b4f42@jbarnes-piketon>
In-Reply-To: <20091217105900.1d8b4f42@jbarnes-piketon>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Thu, 17 Dec 2009 09:55:06 -0800
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> On Thu, 17 Dec 2009 16:58:40 +1100 Stephen Rothwell wrote:
>> 
>>> Hi all,
>>> 
>>> My usual call for calm: please do not put stuff destined for 2.6.34
>>> into linux-next trees until after 2.6.33-rc1.
>>> 
>>> Changes since 20091216:
>> 
>> 
>> When CONFIG_PCI_QUIRKS=n:
>> 
>> drivers/built-in.o: In function `pci_dev_reset':
>> pci.c:(.text+0xdb0b): undefined reference to `pci_dev_reset_methods'
>> pci.c:(.text+0xdb2b): undefined reference to `pci_dev_reset_methods'
>> pci.c:(.text+0xdb85): undefined reference to `pci_dev_reset_methods'
>> 
>> 
>> pci_dev_reset() calls (inlined) pci_dev_specific_reset(),
>> which references pci_dev_reset_methods, which does not exist.
> 
> Dexuan, can you fix this up?
Hi Jesse, 
I have posted a small patch in linux-pci ML just now. 
I can reproduce the build failure and with the patch I posted I can verify the build can pass successfully.
Please have a look.

Thanks,
-- Dexuan