Return-Path: <linux-kernel-owner+w=401wt.eu-S933204AbXEEQCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204AbXEEQCO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933187AbXEEQCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:02:14 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:30798 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933204AbXEEQCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:02:05 -0400
Message-ID: <463C8D72.5070003@interia.pl>
Date: Sat, 05 May 2007 15:58:10 +0200
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070321)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: john stultz <johnstul@us.ibm.com>, davej@codemonkey.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cpufreq@lists.linux.org.uk
Subject: Re: cpufreq longhaul locks up
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr>  <1178311052.6094.0.camel@localhost.localdomain>  <Pine.LNX.4.61.0705042259160.18504@yvahk01.tjqt.qr> <1178318978.6094.29.camel@localhost.localdomain> <Pine.LNX.4.61.0705050130090.18504@yvahk01.tjqt.qr> <463C01FA.8070206@interia.pl> <Pine.LNX.4.61.0705051000030.18504@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705051000030.18504@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
X-EMID: d59faacc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> Switching from acpi_pm+performance to acpi_pm+ondemand also
>>>>> locks up after a few minutes.
>>>> Yep. Sounds like an ondemand issue. Thanks for verifying this for me.
>>> Nah, it also happens with cpufreq_powersave. I just need to check 
>>> through some archives and try booting with governor=powersave so that it 
>>> always stays low. 
>> You have a lockup when switching from other governor to powersave? Or if  
>> You are using it for some time?
> 
> After some time.
Don't understand me wrong, but this is very weird. I think that powersave is  
changing frequency only one time, when it is loaded. I will look into its code 
to be sure. Probably Longhaul is making something what isn't allowed or there 
is hardware bug somewhere.
> Jan
Rafa³



----------------------------------------------------------------------
Po meczu.....kurde...:)
>>> http://link.interia.pl/f1a72

