Return-Path: <linux-kernel-owner+w=401wt.eu-S933029AbXB1PNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933029AbXB1PNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 10:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933036AbXB1PNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 10:13:23 -0500
Received: from terminus.zytor.com ([192.83.249.54]:41528 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933029AbXB1PNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 10:13:22 -0500
Message-ID: <45E59BFC.8020206@zytor.com>
Date: Wed, 28 Feb 2007 07:13:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: "Mathiasen, Torben" <Torben.Mathiasen@hp.com>,
       Timur Tabi <timur@freescale.com>, linux-kernel@vger.kernel.org
Subject: Re: lanana: Add major/minor entries for PPC QE UART devices
References: <45E46976.6060600@freescale.com> <93C4769E3BED6B42B7203BD6F065654C08C5D6E8@dmoexc01.emea.cpqcorp.net> <45E57CE5.5010003@zytor.com> <93C4769E3BED6B42B7203BD6F065654C08C5D7FF@dmoexc01.emea.cpqcorp.net> <45E593C2.6020004@freescale.com> <93C4769E3BED6B42B7203BD6F065654C08C5D8FD@dmoexc01.emea.cpqcorp.net> <0DA3FFD2-CFB8-44FB-872B-00D85B11213B@kernel.crashing.org>
In-Reply-To: <0DA3FFD2-CFB8-44FB-872B-00D85B11213B@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:
> 
> On Feb 28, 2007, at 8:51 AM, Mathiasen, Torben wrote:
> 
>>>
>>> Mathiasen, Torben wrote:
>>>
>>>> Assuming QE has 4 entries, I would expect CPM to be the same. But we
>>>> need verification of that. If it needs 6, we are in more trouble.
>>>
>>> The QE can have up to 8, actually, but I'm willing to limit the driver
>>> to 4.
>>
>> Its your choice if you want to limit it to 4 or have it moved into a
>> different minor range. I can live with both.
> 
> I'd rather we support 8 now.
> 

It sounds like the QE driver should be moved to a separate minor range, 
and given 8 minors.

	-hpa
