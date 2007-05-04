Return-Path: <linux-kernel-owner+w=401wt.eu-S1161558AbXEDXd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161558AbXEDXd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 19:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbXEDXd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 19:33:56 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:54449 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275AbXEDXdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 19:33:55 -0400
Date: Sat, 5 May 2007 01:32:04 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: john stultz <johnstul@us.ibm.com>
cc: davej@codemonkey.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cpufreq@lists.linux.org.uk
Subject: Re: cpufreq longhaul locks up
In-Reply-To: <1178318978.6094.29.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.61.0705050130090.18504@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr> 
 <1178311052.6094.0.camel@localhost.localdomain> 
 <Pine.LNX.4.61.0705042259160.18504@yvahk01.tjqt.qr>
 <1178318978.6094.29.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 4 2007 15:49, john stultz wrote:
>
>> Switching from acpi_pm+performance to acpi_pm+ondemand also
>> locks up after a few minutes.
>
>Yep. Sounds like an ondemand issue. Thanks for verifying this for me.

Nah, it also happens with cpufreq_powersave. I just need to check 
through some archives and try booting with governor=powersave so that it 
always stays low. Though, lowering the frequency does not really buy any 
temperature improvement in 60 seconds, so I don't think I will need 
cpufreq anyway (other processors have a noticable jump in core 
temperature between 100%idle and a busy loop).


Jan
-- 
