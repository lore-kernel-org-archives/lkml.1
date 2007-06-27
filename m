Return-Path: <linux-kernel-owner+w=401wt.eu-S1762137AbXF0Sec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762137AbXF0Sec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 14:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757259AbXF0SeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 14:34:25 -0400
Received: from terminus.zytor.com ([192.83.249.54]:34988 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbXF0SeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 14:34:24 -0400
Message-ID: <4682AD9B.9060105@zytor.com>
Date: Wed, 27 Jun 2007 14:34:03 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Matthew Wilcox <matthew@wil.cx>, Matt Domsch <Matt_Domsch@dell.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: pci.h stubs
References: <20070626132622.3226261a.randy.dunlap@oracle.com>	<20070627024505.GA30197@humbolt.us.dell.com>	<20070627113048.GU22063@parisc-linux.org>	<20070627145500.2e66fd49@the-village.bc.nu>	<46829345.1000607@zytor.com>	<20070627165429.GY22063@parisc-linux.org> <20070627182518.50423241@the-village.bc.nu>
In-Reply-To: <20070627182518.50423241@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Wed, 27 Jun 2007 10:54:30 -0600
> Matthew Wilcox <matthew@wil.cx> wrote:
> 
>> On Wed, Jun 27, 2007 at 12:41:41PM -0400, H. Peter Anvin wrote:
>>> Note that EDD has no way of referencing anything but the zero domain 
>>> (which is presumably the one which is addressed by I/O ports CF8/CFC on 
>>> the BSP.)  So in this particular case I would say pci_get_bus_and_slot() 
>>> is fine.
>> Except that you're not guaranteed to get the bus that's in domain zero.
> 
> Which is trivial to fix

Yes, and that's probably the only sane definition of that API.

	-hpa
