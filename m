Return-Path: <linux-kernel-owner+w=401wt.eu-S1755194AbZHKPJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbZHKPJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 11:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbZHKPJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 11:09:32 -0400
Received: from exprod5og106.obsmtp.com ([64.18.0.182]:45813 "EHLO
	exprod5og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbZHKPJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 11:09:31 -0400
Message-ID: <4A8189D9.4080709@gefanuc.com>
Date: Tue, 11 Aug 2009 16:10:17 +0100
From: Martyn Welch <martyn.welch@gefanuc.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 1/5] Staging: VME Framework for the Linux Kernel
References: <20090803205657.964064732@mini.kroah.org> <20090803210111.GB28430@kroah.com> <20090808230145.GB27151@braap.org> <4A801644.2070009@gefanuc.com> <20090810141442.GA18456@braap.org> <4A804283.5090009@gefanuc.com> <20090810193849.GA3055@braap.org> <4A812BCE.3010003@gefanuc.com> <20090811144914.GB32658@braap.org>
In-Reply-To: <20090811144914.GB32658@braap.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emilio G. Cota wrote:
> Martyn Welch wrote:
>   
>> Again: what part of the API I have defined forces the driver to know  
>> about the underlying bridge?
>>     
>
> Let me answer with another question, maybe we get to understand
> each other this way:
>
> Could you please explain me what happens when 17 different drivers
> want to control 17 different devices, each on a different slot,
> same address modifier, only 1MB per device? Apply if necessary
> to the tsi148 bridge.
>   

Not the same question, but I'd agree - that would probably break the 
current model I have proposed. *However*, providing a resource 
management layer as you have proposed above the basic resource 
management my API provides would resolve that without added complexity 
in the bridge drivers themselves.

> NB1. Any given driver knows nothing about the other devices
> on the crate; each driver only knows about the address, am and
> size of the mapping for the device it controls--user-space
> provide this info on a per-driver basis.
>   
Yes. I agree.
> NB2. The mapping offsets configured through the cards' pins match
> the information passed from user space to each of the cards.
>
>   
Yes. If I understand you correctly, your saying that management of the 
devices in the VME address space is a system configuration issue.

> Cheers,
> E.
>   
-- 
Martyn Welch MEng MPhil MIET (Principal Software Engineer)   T:+44(0)1327322748
GE Fanuc Intelligent Platforms Ltd,        |Registered in England and Wales
Tove Valley Business Park, Towcester,      |(3828642) at 100 Barbirolli Square,
Northants, NN12 6PF, UK T:+44(0)1327359444 |Manchester,M2 3AB  VAT:GB 927559189
