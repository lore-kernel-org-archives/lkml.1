Return-Path: <linux-kernel-owner+w=401wt.eu-S1759529AbYG1BNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529AbYG1BNe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 21:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbYG1BN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 21:13:27 -0400
Received: from senator.holtmann.net ([87.106.208.187]:51527 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbYG1BN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 21:13:26 -0400
Cc: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
       linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, kkeil@suse.de
Message-Id: <7949EA87-4340-4353-AFC9-79A718B95DF0@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: David Miller <davem@davemloft.net>
In-Reply-To: <20080727.180736.74131389.davem@davemloft.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v928.1)
Subject: Re: mISDN still breaking the allmodconfig build...
Date: Mon, 28 Jul 2008 03:13:21 +0200
References: <20080727.170235.97056809.davem@davemloft.net> <93120C4B-D2F4-4479-806B-2141AC3DC607@holtmann.org> <20080727.180736.74131389.davem@davemloft.net>
X-Mailer: Apple Mail (2.928.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

>>> More fallout from the premature mISDN driver merge:
>>>
>>> drivers/isdn/hardware/mISDN/hfcmulti.c:5255:2: error: #error "not
>>> running on big endian machines now"
>>
>> is that only the HFC driver or the whole mISDN stack?
>>
>> I know that the two old ISDN stacks where really bad on big endian,
>> but my assumption was that we did sort this out in the end.
>
> One of the two mISDN drivers uses the deprecated virt_to_bus()
> interface for handling DMA addresses (that doesn't even work on many
> x86 systems these days) and the other mISDN driver gives the above
> big-endian compile time error.
>
> In short, this driver was not ready for merging at all.

I am not defending it and agree that this driver should have had at  
least one test run in linux-next. However mISDN is a whole ISDN stack.  
So does mISDN has an issue too or do we only have a really broken  
driver. Karsten?

Regards

Marcel

