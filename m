Return-Path: <linux-kernel-owner+w=401wt.eu-S965528AbXAWWHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965528AbXAWWHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:07:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965521AbXAWWHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:07:07 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:51168 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965547AbXAWWGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:06:53 -0500
Message-ID: <45B686EB.60508@garzik.org>
Date: Tue, 23 Jan 2007 17:06:35 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Hemminger <shemminger@linux-foundation.org>,
       Luca Tettamanti <kronos.it@gmail.com>,
       Jay Cliburn <jacliburn@bellsouth.net>, shemminger@osdl.org,
       csnook@redhat.com, hch@infradead.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, atl1-devel@lists.sourceforge.net
Subject: Re: [PATCH 4/4] atl1: Ancillary C files for Attansic L1 driver
References: <20070121210737.GE2702@osprey.hogchain.net>	<20070121183151.4be61ebf.randy.dunlap@oracle.com>	<45B43093.6060500@bellsouth.net>	<20070122200004.GA12553@dreamland.darkstar.lan>	<20070123112522.65aac61b@freekitty>	<45B67F29.4010703@garzik.org> <20070123133409.17a32128@freekitty> <45B68249.90507@oracle.com>
In-Reply-To: <45B68249.90507@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> Stephen Hemminger wrote:
>> On Tue, 23 Jan 2007 16:33:29 -0500
>> Jeff Garzik <jeff@garzik.org> wrote:
>>
>>> Stephen Hemminger wrote:
>>>> IMHO the MSI disabling should be removed from drivers and be done
>>>> in the PCI core.
>>> That is the consensus opinion.
>>>
>>> Currently drivers implement the MSI tests because the core PCI code 
>>> hasn't been up to snuff.  I (and others) have been discouraging that, 
>>> but when a user faces a choice between working and non-working 
>>> network, the pragmatic solution wins.
> 
> Linus's remark (IIRC) was to not enable CONFIG_PCI_MSI then.

Most distros, especially cutting edge ones like Fedora, will enable 
CONFIG_PCI_MSI.


>>> All efforts to get us to the point where we can remove the MSI tests 
>>> from drivers are strongly supported...
>>>
>>>     Jeff
>>
>> So far, either MSI works for all devices or is broken, so it makes
>> sense to have a "msi=off" boot option (if there isn't already)
>>
> There is one, but it's spelled "pci=nomsi".

Yep.  Thanks for repeating this, and refreshing the collective memory.

	Jeff



