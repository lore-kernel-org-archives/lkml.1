Return-Path: <linux-kernel-owner+w=401wt.eu-S1756207AbYJVREh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbYJVREh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbYJVRES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:04:18 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:62954 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbYJVRER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:04:17 -0400
Message-ID: <48FF5C62.3020008@oracle.com>
Date: Wed, 22 Oct 2008 10:01:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Yu Zhao <yu.zhao@intel.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "achiang@hp.com" <achiang@hp.com>, "matthew@wil.cx" <matthew@wil.cx>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>, "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH 16/16 v6] PCI: document the new PCI boot parameters
References: <20081022083809.GA3757@yzhao12-linux.sh.intel.com>	<20081022084531.GP3773@yzhao12-linux.sh.intel.com> <200810220827.33758.bjorn.helgaas@hp.com>
In-Reply-To: <200810220827.33758.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010202.48FF5C67.0087:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Wednesday 22 October 2008 02:45:31 am Yu Zhao wrote:
>> Document the new PCI[x86] boot parameters.
>>
>> Cc: Alex Chiang <achiang@hp.com>
>> Cc: Grant Grundler <grundler@parisc-linux.org>
>> Cc: Greg KH <greg@kroah.com>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
>> Cc: Matthew Wilcox <matthew@wil.cx>
>> Cc: Randy Dunlap <randy.dunlap@oracle.com>
>> Cc: Roland Dreier <rdreier@cisco.com>
>> Signed-off-by: Yu Zhao <yu.zhao@intel.com>
>>
>> ---
>>  Documentation/kernel-parameters.txt |   10 ++++++++++
>>  1 files changed, 10 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index 53ba7c7..5482ae0 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -1677,6 +1677,16 @@ and is between 256 and 4096 characters. It is defined in the file
>>  		cbmemsize=nn[KMG]	The fixed amount of bus space which is
>>  				reserved for the CardBus bridge's memory
>>  				window. The default value is 64 megabytes.
>> +		assign-mmio=[dddd:]bb	[X86] reassign memory resources of all
>> +				devices under bus [dddd:]bb (dddd is the domain
>> +				number and bb is the bus number).
>> +		assign-pio=[dddd:]bb	[X86] reassign io port resources of all

"io" in text should be "IO" or "I/O".  (Small "io" is OK as a parameter placeholder.)

>> +				devices under bus [dddd:]bb (dddd is the domain
>> +				number and bb is the bus number).
>> +		align-mmio=[dddd:]bb:dd.f  [X86] relocate memory resources of a
>> +				device to minimum PAGE_SIZE alignment (dddd is
>> +				the domain number and bb, dd and f is the bus,

				                                   are the bus,

>> +				device and function number).
>>  
>>  	pcie_aspm=	[PCIE] Forcibly enable or disable PCIe Active State Power
>>  			Management.
> 
> I think it's nicer to have the documentation change included in the
> patch that implements the change.  For example, I think this and
> patch 9/16 "add boot option to align ..." should be folded into
> a single patch.  And similarly for the other documentation patches.
> 
> Bjorn

