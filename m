Return-Path: <linux-kernel-owner+w=401wt.eu-S1762200AbYAKU1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762200AbYAKU1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 15:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757521AbYAKU1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 15:27:25 -0500
Received: from gate.crashing.org ([63.228.1.57]:53429 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbYAKU1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 15:27:24 -0500
Cc: LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       linux-pci@atrey.karlin.mff.cuni.cz
Message-Id: <E1025115-6BE2-46B6-8416-A5ADD506E2ED@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Greg KH <greg@kroah.com>
In-Reply-To: <20080111175039.GB7916@kroah.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: PCI Failed to allocate mem for PCI ROM
Date: Fri, 11 Jan 2008 14:27:16 -0600
References: <1B75C5A8-E512-40CB-A6F3-351640701D0D@kernel.crashing.org> <20080111175039.GB7916@kroah.com>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 11, 2008, at 11:50 AM, Greg KH wrote:

> On Fri, Jan 11, 2008 at 02:29:28AM -0600, Kumar Gala wrote:
>> Greg,
>>
>> I'm getting the following message from the kernel on an embedded  
>> ppc32
>> system:
>>
>> PCI: Failed to allocate mem resource #9:100000@e0000000 for  
>> 0000:00:00.0
>>
>> The HW setup is a PCIe host controller and an e1000 NIC card.  It  
>> appears
>> that pci_bus_assign_resources() is trying to call  
>> pci_assign_resource() for
>> the ROM and the resource for the ROM is [100000:1fffff] where the  
>> PHB is
>> [c0000000:dfffffff].
>>
>> It seems like the resno that pci_assign_resource is getting called  
>> with is
>> wrong and thus pci_update_resource() doesn't get called.
>>
>> any ideas?
>
> Nope, sorry, any help debugging this is appreciated, pci resource
> allocation is "tricky" :)

I'm happy to debug, is the fact that the resno == 9 ok or does that  
seem wrong?

- k
