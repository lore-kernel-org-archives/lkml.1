Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbYAPT7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbYAPT7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 14:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbYAPT7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 14:59:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40295 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbYAPT7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 14:59:13 -0500
Message-ID: <478E5FD8.5060906@zytor.com>
Date: Wed, 16 Jan 2008 14:49:44 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org,
       Russell King <rmk+serial@arm.linux.org.uk>,
       Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/2] 8250_pnp: register x86 COM ports at the conventional
 ttyS names
References: <20080116170541.511233227@ldl.fc.hp.com> <20080116170914.959390017@ldl.fc.hp.com> <478E5095.2020803@zytor.com> <200801161247.34821.bjorn.helgaas@hp.com>
In-Reply-To: <200801161247.34821.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
>>> +
>> Arguably, the right thing is to use the addresses present in the array 
>> at address 0x400.  In particular, COM3 and COM4 aren't always at those 
>> addresses.
> 
> Wow.  I bow before your storehouse of x86 arcana :-)
> 
> I guess you're referring to the "BIOS data area," which I'd never
> heard of before (but fortunately, Google knows).
> 
> What would you think about doing this only for COM1 and COM2?  The
> only real value for doing this in the first place is so "console=ttyS0"
> always goes to COM1, even if we don't have SERIAL_PORT_DFNS.  User-
> space ought to use some sort of udev magic if it cares about persistent
> naming.
> 

Well, there are four ports that the BIOS have slots for, and if so, we 
probably should use them.

	-hpa
