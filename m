Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbXEEIDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbXEEIDF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 04:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbXEEIDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 04:03:04 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:41979 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875AbXEEIDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 04:03:00 -0400
Date: Sat, 5 May 2007 10:00:21 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
cc: john stultz <johnstul@us.ibm.com>, davej@codemonkey.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cpufreq@lists.linux.org.uk
Subject: Re: cpufreq longhaul locks up
In-Reply-To: <463C01FA.8070206@interia.pl>
Message-ID: <Pine.LNX.4.61.0705051000030.18504@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr> 
 <1178311052.6094.0.camel@localhost.localdomain> 
 <Pine.LNX.4.61.0705042259160.18504@yvahk01.tjqt.qr>
 <1178318978.6094.29.camel@localhost.localdomain>
 <Pine.LNX.4.61.0705050130090.18504@yvahk01.tjqt.qr> <463C01FA.8070206@interia.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 5 2007 06:03, Rafał Bilski wrote:
>
>>>> Switching from acpi_pm+performance to acpi_pm+ondemand also
>>>> locks up after a few minutes.
>>> Yep. Sounds like an ondemand issue. Thanks for verifying this for me.
>> 
>> Nah, it also happens with cpufreq_powersave. I just need to check 
>> through some archives and try booting with governor=powersave so that it 
>> always stays low. 
>
>You have a lockup when switching from other governor to powersave? Or if  
>You are using it for some time?

After some time.



Jan
-- 
