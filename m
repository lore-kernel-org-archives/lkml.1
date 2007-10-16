Return-Path: <linux-kernel-owner+w=401wt.eu-S933761AbXJPPQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933761AbXJPPQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 11:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759120AbXJPPQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 11:16:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758845AbXJPPQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 11:16:15 -0400
Message-ID: <4714D5B8.8020301@redhat.com>
Date: Tue, 16 Oct 2007 11:16:08 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Konstantin Kalin <konstantin.kalin@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: NVIDIA Ethernet & invalid MAC
References: <4714C66D.4010607@gmail.com> <20071016154313.53d19c43@the-village.bc.nu>
In-Reply-To: <20071016154313.53d19c43@the-village.bc.nu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2007 10:43 AM, Alan Cox wrote:
> On Tue, 16 Oct 2007 18:10:53 +0400
> Konstantin Kalin <konstantin.kalin@gmail.com> wrote:
> 
>> Hello,
>>
>> Recently we've got some computers with new motherboard having NVidia 
>> chipset. The motherboard has nforce12 & nforce13 Ethernet cards. I've 
>> noticed that MAC address is setup random each boot. I debugged the 
>> driver and found that these cards have right-byte order of MAC address 
>> but the driver is expecting incorrect byte-order for these models.
> 
> The only obvious thing I can think of to try would be to read the MAC
> address both ways around.
> 
> The first 3 bytes of the resulting MAC should always be the Nvidia
> allocation as I understand it and if so you can then decide which way
> around is correct. 
> 
> ie if it starts 00:04:0B then you know which way around it goes. (there
> is one address that is the same either way around but clearly that one
> doesn't matter).
> 
> So perhaps do that and for the afflicted parts add an EITHER_WAY_AROUND
> flag ?
> 

See the below for another report of this:

http://marc.info/?t=119215716900001&r=1&w=2

And apparently some motherboard vendors have their own allocations for ethernet
addresses?

