Return-Path: <linux-kernel-owner+w=401wt.eu-S1752172AbXAaFTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbXAaFTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 00:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbXAaFTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 00:19:18 -0500
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:29816 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752172AbXAaFTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 00:19:17 -0500
In-Reply-To: <20070130211153.4ca1aaa7.akpm@osdl.org>
References: <Pine.LNX.4.64.0701302251520.5644@localhost.localdomain> <20070130211153.4ca1aaa7.akpm@osdl.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <6543410C-B60C-4706-AB4E-FA64C4E592F5@kernel.crashing.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: Reducing warning output from pci_get_subsys()
Date: Tue, 30 Jan 2007 23:18:21 -0600
To: Andrew Morton <akpm@osdl.org>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 30, 2007, at 11:11 PM, Andrew Morton wrote:

> On Tue, 30 Jan 2007 22:55:38 -0600 (CST)
> Kumar Gala <galak@kernel.crashing.org> wrote:
>
>> Greg,
>>
>> There was some code added to warn if pci_get_subsys() is called  
>> and the
>> pci_devices is empty.
>>
>> I'm wondering if there is some point at which we know its ok for the
>> pci_devices list be empty if there are no devices on the bus so we  
>> can
>> stop printing the message.
>>
>> On an embedded PPC reference system I see this message 6 times  
>> when I've
>> got no cards in the PCI slots.
>>
>
> I'd suggest we just remove the warning.  Also the one in  
> pci_find_subsys().
>
> I let them go through because I was curious to know what would  
> cause it to
> trigger - it might be an indication of other bugs.  But nothing very
> interesting happened and they're of no use.

Works for me.

- k
