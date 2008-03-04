Return-Path: <linux-kernel-owner+w=401wt.eu-S1759384AbYCDFy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384AbYCDFy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 00:54:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756101AbYCDFx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 00:53:59 -0500
Received: from mailout08.sul.t-online.de ([194.25.134.20]:45406 "EHLO
	mailout08.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755628AbYCDFx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 00:53:56 -0500
Message-ID: <47CCE3E9.9080302@t-online.de>
Date: Tue, 04 Mar 2008 06:53:45 +0100
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Mike@Keehan.net, linux-kernel@vger.kernel.org
Subject: Re: strange behavior on multimedia eject button for cdrom
References: <47C15020.8040806@t-online.de>	<47C7FECD.3040205@Keehan.net>	<47CB11FA.60008@t-online.de> <20080302125402.4af85abc@laptopd505.fenrus.org> <47CC7470.5020009@t-online.de>
In-Reply-To: <47CC7470.5020009@t-online.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: Saf3b2ZEZhHEZmSn8IS9b6cp0-n37ny3oNJdGvGSFEHtIgjT+53uHd-E0XO2qqLw0k
X-TOI-MSGID: ddc5efc1-f8e6-473f-a6c5-7a4d11eae0a3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update: The original problem is _not_ gone yet. Now it takes
just 2 seconds to eject the CD (since it is not spinning by
default), but the sound and network are still affected during
this time.

On this page

	http://bugs.debian.org/370186

you can find some information to tell HAL to ignore the CD
drive.


Regards

Harri
================================================================
Harald Dunkel wrote:
> Hi Arjan,
> 
> Arjan van de Ven wrote:
>>
>> try (temporarily) disable the hal storage polling thing.....
>> that could well avoid the entire issue.
>>
>>
> 
> Now _that_ was an improvement. After hald has been stopped the problem
> is gone.
> 
> Even better: Seems that hald was responsible for keeping my CD drive
> spinning all the time. Since hald is gone the CD drive stops spinning
> after a few seconds :-). And playing DVDs the whole system is _much_
> more responsive, the DVD navigation menus are faster, etc.
> 
> Hopefully there is a configure option to tell hald to keep the CD drive
> alone.
> 
> 
> Thanx very much
> 
> Harri
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Dipl.-Ing. Harald Dunkel     | Today's weirdness is tomorrow's reason why.
Muehlenbachstr. 3            |                       -- Hunter S. Thompson
52134 Herzogenrath, Germany  |
+49 2407 565 105             |
