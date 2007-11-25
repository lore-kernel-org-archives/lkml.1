Return-Path: <linux-kernel-owner+w=401wt.eu-S1754427AbXKYHy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbXKYHy2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 02:54:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbXKYHyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 02:54:19 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:35135 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbXKYHyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 02:54:18 -0500
Message-ID: <47492A1F.4030106@davidnewall.com>
Date: Sun, 25 Nov 2007 18:24:07 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: mhw@WittsEnd.com
CC: Andrey Borzenkov <arvidjaar@mail.ru>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: 2.6.24: Serial disabled in BIOS but serial modules still	loaded
 (probably PnP related)
References: <200711242336.43712.arvidjaar@mail.ru> <1195962922.5044.8.camel@canyon.wittsend.com>
In-Reply-To: <1195962922.5044.8.camel@canyon.wittsend.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael H. Warfield wrote:
> On Sat, 2007-11-24 at 23:36 +0300, Andrey Borzenkov wrote:
>   
>> I have no COM port on notebook (without port replicator which I do not have)
>> so COM is disabled in BIOS. No ttyS* is detected during boot (and no device
>> created) but I just noticed that serial modules are still loaded. Well, this
>> partially defeats the purpose of disabling COM port - the intention was to
>> free resources by *not* loading unneeded modules ...
>>     
>
>   
>> This may have something to do with (ACPI) PnP which apparently believes COM is alive.
>> Notebook is Toshiba Portege 4000.
>>     
>
> 	Nice...  What's this then?
>
>   
>> 00:09 PNP0501 16550A-compatible serial port
>>     state = active
>>         io 0x3f8-0x3ff
>>         irq 5
>>     

This doesn't mean that a port (ie connector) is present.  My notebook 
also has the electronics without the physical connector.
