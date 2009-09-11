Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbZIKQ1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbZIKQ1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 12:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbZIKQ1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 12:27:43 -0400
Received: from exprod5og114.obsmtp.com ([64.18.0.28]:33710 "EHLO
	exprod5og114.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622AbZIKQ1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 12:27:42 -0400
Message-ID: <4AAA7AEB.803@gefanuc.com>
Date: Fri, 11 Sep 2009 17:29:31 +0100
From: Martyn Welch <martyn.welch@gefanuc.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
       Linux-Next <linux-next@vger.kernel.org>
Subject: Re: drivers/staging/vme/Kconfig:5:warning: type of 'VME' redefined
 from 'boolean' to 'tristate'
References: <10f740e80909110726x313e3e3coe2321c683163e3a5@mail.gmail.com> <20090911150210.GB16593@kroah.com>
In-Reply-To: <20090911150210.GB16593@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Fri, Sep 11, 2009 at 04:26:36PM +0200, Geert Uytterhoeven wrote:
>   
>> http://kisskb.ellerman.id.au/kisskb/buildresult/1221192/:
>> drivers/staging/vme/Kconfig:5:warning: type of 'VME' redefined from
>> 'boolean' to 'tristate'
>> drivers/staging/vme/Kconfig:5:warning: type of 'VME' redefined from
>> 'boolean' to 'tristate'
>>
>> We already have:
>>
>> arch/m68k/Kconfig:config VME
>> arch/m68k/Kconfig:      bool "VME (Motorola and BVM) support"
>> arch/m68k/Kconfig:        Say Y here if you want to build a kernel for
>> a 680x0 based VME
>>     
>
> Ah, not good.
>
> Are these a board-specific thing?  It's not the "VME bus" is it?
>
> Martyn, maybe we should rename CONFIG_VME to CONFIG_VME_BUS ?
>
> thanks,
>
> greg k-h
>   
Agreed - Not good.

I'll try and rustle up a patch ASAP, but it might not be until Monday 
now - I unfortunately have a rather busy weekend. I'm more than happy 
with CONFIG_VME_BUS if someone beats me to it.

Martyn

-- 
Martyn Welch MEng MPhil MIET (Principal Software Engineer)   T:+44(0)1327322748
GE Fanuc Intelligent Platforms Ltd,        |Registered in England and Wales
Tove Valley Business Park, Towcester,      |(3828642) at 100 Barbirolli Square,
Northants, NN12 6PF, UK T:+44(0)1327359444 |Manchester,M2 3AB  VAT:GB 927559189
