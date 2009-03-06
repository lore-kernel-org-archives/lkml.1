Return-Path: <linux-kernel-owner+w=401wt.eu-S1756435AbZCFWd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435AbZCFWd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbZCFWdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:33:46 -0500
Received: from xenotime.net ([72.52.64.118]:60603 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753193AbZCFWdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:33:44 -0500
Message-ID: <49B1A52C.4080702@xenotime.net>
Date: Fri, 06 Mar 2009 14:35:24 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Yu Zhao <yu.zhao@intel.com>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 6/7] PCI: document SR-IOV sysfs entries
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com> <1235112888-9524-7-git-send-email-yu.zhao@intel.com> <20090306211614.GI25995@parisc-linux.org>
In-Reply-To: <20090306211614.GI25995@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> Randy, can you wordsmith this one?

I'll try.

> I think I'm starting to understand the difference between physfn and
> dep_link, but an example would definitely help.  It may or may not be
> appropriate to put it in.
> 
> On Fri, Feb 20, 2009 at 02:54:47PM +0800, Yu Zhao wrote:
>> Signed-off-by: Yu Zhao <yu.zhao@intel.com>
>> ---
>>  Documentation/ABI/testing/sysfs-bus-pci |   27 +++++++++++++++++++++++++++
>>  1 files changed, 27 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
>> index ceddcff..84dc100 100644
>> --- a/Documentation/ABI/testing/sysfs-bus-pci
>> +++ b/Documentation/ABI/testing/sysfs-bus-pci
>> @@ -9,3 +9,30 @@ Description:
>>  		that some devices may have malformatted data.  If the
>>  		underlying VPD has a writable section then the
>>  		corresponding section of this file will be writable.
>> +
>> +What:		/sys/bus/pci/devices/.../virtfn/N
>> +Date:		February 2009
>> +Contact:	Yu Zhao <yu.zhao@intel.com>
>> +Description:
>> +		This symbol link appears when hardware supports SR-IOV

		     symbolic                          supports the SR-IOV

>> +		capability and Physical Function driver has enabled it.

		               ^the | its | a

>> +		The symbol link points to the PCI device sysfs entry of

		    symbolic 

>> +		Virtual Function whose index is N (0...MaxVFs-1).

		the Virtual Function

>> +
>> +What:		/sys/bus/pci/devices/.../virtfn/dep_link
>> +Date:		February 2009
>> +Contact:	Yu Zhao <yu.zhao@intel.com>
>> +Description:
>> +		This symbol link appears when hardware supports SR-IOV

		     symbolic                          supports the SR-IOV

>> +		capability and Physical Function driver has enabled it,

		               ^its | the | a

>> +		and this device has vendor specific dependencies with
>> +		others. The symbol link points to the PCI device sysfs

		            symbolic

>> +		entry of Physical Function this device depends on.
>> +
>> +What:		/sys/bus/pci/devices/.../physfn
>> +Date:		February 2009
>> +Contact:	Yu Zhao <yu.zhao@intel.com>
>> +Description:
>> +		This symbol link appears when a device is Virtual Function.

		     symbolic                          is a Virtual Function.

>> +		The symbol link points to the PCI device sysfs entry of

		    symbolic                                   entry of the

>> +		Physical Function this device associates with.

