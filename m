Return-Path: <linux-kernel-owner+w=401wt.eu-S1753450AbZHKQhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbZHKQhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 12:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbZHKQhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 12:37:39 -0400
Received: from exprod5og111.obsmtp.com ([64.18.0.22]:56079 "EHLO
	exprod5og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbZHKQhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 12:37:39 -0400
Message-ID: <4A819E80.90103@gefanuc.com>
Date: Tue, 11 Aug 2009 17:38:24 +0100
From: Martyn Welch <martyn.welch@gefanuc.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 1/5] Staging: VME Framework for the Linux Kernel
References: <20090808230145.GB27151@braap.org> <4A801644.2070009@gefanuc.com> <20090810141442.GA18456@braap.org> <4A804283.5090009@gefanuc.com> <20090810193849.GA3055@braap.org> <4A812BCE.3010003@gefanuc.com> <20090811144914.GB32658@braap.org> <4A8189D9.4080709@gefanuc.com> <20090811153633.GC32658@braap.org> <4A819130.5080802@gefanuc.com> <20090811154226.GD32658@braap.org>
In-Reply-To: <20090811154226.GD32658@braap.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emilio G. Cota wrote:
> Martyn Welch wrote:
>   
>>> It wouldn't break it, the model simply couldn't give you more
>>> than 8 windows-->8 devices.
>>>   
>>>       
>> Unless the devices we the same and the driver reused one window.
>>     
>
> No, we agreed on that devices should know *nothing* about windows.
>
>   
Don't think I did. :-)

I agreed that it would be impossible to assign sole use of 8 resources 
to 17 different drivers. I feel that there could be room and indeed a 
need for both approaches. It may be more efficient for a driver to use 
and move 1 window to position it's self over the registers of each of a 
number of compatible devices as required. Such a driver could exist 
side-by-side with drivers using your approach, that utilize a layer 
which removes such control. Whilst I understand you can assign a fairly 
sizable chunk of memory mapped IO for VME, this is not always the case. 
In situations where the available memory mapped IO is limited, placing a 
large window to cover 2 smaller windows with dead space in between them 
will not be an adequate solution either.

Martyn
> E.
>   


-- 
Martyn Welch MEng MPhil MIET (Principal Software Engineer)   T:+44(0)1327322748
GE Fanuc Intelligent Platforms Ltd,        |Registered in England and Wales
Tove Valley Business Park, Towcester,      |(3828642) at 100 Barbirolli Square,
Northants, NN12 6PF, UK T:+44(0)1327359444 |Manchester,M2 3AB  VAT:GB 927559189
