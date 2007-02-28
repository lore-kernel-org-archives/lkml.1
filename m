Return-Path: <linux-kernel-owner+w=401wt.eu-S932869AbXB1Ods@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869AbXB1Ods (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 09:33:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932872AbXB1Odr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 09:33:47 -0500
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:49114 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932869AbXB1Odq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 09:33:46 -0500
In-Reply-To: <93C4769E3BED6B42B7203BD6F065654C08C5D7FF@dmoexc01.emea.cpqcorp.net>
References: <45E46976.6060600@freescale.com> <93C4769E3BED6B42B7203BD6F065654C08C5D6E8@dmoexc01.emea.cpqcorp.net> <45E57CE5.5010003@zytor.com> <93C4769E3BED6B42B7203BD6F065654C08C5D7FF@dmoexc01.emea.cpqcorp.net>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <0A729FA4-5C52-4CF2-A305-7B7E4CCF9D55@kernel.crashing.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Timur Tabi" <timur@freescale.com>,
       <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: lanana: Add major/minor entries for PPC QE UART devices
Date: Wed, 28 Feb 2007 08:32:39 -0600
To: "Mathiasen, Torben" <Torben.Mathiasen@hp.com>
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


On Feb 28, 2007, at 7:14 AM, Mathiasen, Torben wrote:

>> Mathiasen, Torben wrote:
>>>
>>> Got around looking at this one. I'm fine with this approach, but the
>>> CPM5 fix looks wrong. Shouldn't it be:
>>>
>>> 49 = /dev/ttyCPM3		PPC CPM (SCC or SMC) - port 3
>>>
>>> instead?
>>>
>>
>> Well, how many CPM devices can exist?  If there are really 6 ports
>> possible, they need minors up to 51.
>>
>> Also, if QE really is just CPM v3, and they share the same minors,  
>> why
>> change the name?
>>
>
> Assuming QE has 4 entries, I would expect CPM to be the same. But we
> need verification of that. If it needs 6, we are in more trouble.

I think it really is 6 for the current CPM, and I don't see why we  
its not 8 for QE, Timur?

- k
