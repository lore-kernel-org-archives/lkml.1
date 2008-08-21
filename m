Return-Path: <linux-kernel-owner+w=401wt.eu-S1757684AbYHUARb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684AbYHUARb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 20:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbYHUARX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 20:17:23 -0400
Received: from relay04.mail-hub.dodo.com.au ([123.2.6.239]:55401 "EHLO
	relay04.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753417AbYHUARW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 20:17:22 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Grant Coady <gcoady.lk@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ATA Kconfig cleanup: sort the driver list and modify some text
Date: Thu, 21 Aug 2008 10:16:49 +1000
Organization: http://bugsplatter.id.au/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <tecpa4928hh8kahc53p019sr7nclg8kbjr@4ax.com>
References: <qjoca411hv4hm25keq70ul5pnbi7747d13@4ax.com> <18598.42334.73411.476062@harpo.it.uu.se> <20080816113224.5562a9a6@lxorguk.ukuu.org.uk> <5rkha4l846d0benss3hip3nvr0cmnfi1k4@4ax.com> <m3vdxvqnbb.fsf@maximus.localdomain>
In-Reply-To: <m3vdxvqnbb.fsf@maximus.localdomain>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2008 01:27:52 +0200, Krzysztof Halasa <khc@pm.waw.pl> wrote:

>Grant Coady <grant_lkml@dodo.com.au> writes:
>
>> --- linux-2.6.27-rc3a/drivers/ata/Kconfig	2008-07-14 07:51:29.000000000 +1000
>> +++ linux-2.6.27-rc3c/drivers/ata/Kconfig	2008-08-18 11:29:20.871422237 +1000
>> @@ -3,7 +3,7 @@
>>  #
>>  
>>  menuconfig ATA
>> -	tristate "Serial ATA (prod) and Parallel ATA (experimental) drivers"
>> +	tristate "Serial ATA and Parallel ATA (SATA/PATA) drivers"
>
>I don't think so. Maybe
>> +	tristate "Serial ATA (SATA) and Parallel ATA (PATA) drivers"

Yes, I think that's what I had before.
>
>>  config ATA_SFF
>>  	bool "ATA SFF support"
>>  	default y
>> @@ -93,123 +93,15 @@
>>  
>>  if ATA_SFF
>
>How the user compiling the kernel knows what ATA_SFF stands for?

They read the help text :)  

Perhaps add (legacy drivers) to the SFF menu item?  But that's not 
quite true either.  

>Why not "select ATA_SFF" instead (when any driver using this is
>selected)?

Because then the driver list is always visible?  I'll try it next time 
I look at the patch (when -rc4 is out), I think cleanups wait for next 
merge window anyway.  Perhaps I'll offer both alternatives and see which 
gets picked up.

Besides, I don't like the way select locks in stuff at the moment, means 
you have to turn off every option to get rid of the forced select option 
 -- I'd rather see turning off a 'select'ed item drop all of its 
dependencies.  

Cheers,
Grant.
