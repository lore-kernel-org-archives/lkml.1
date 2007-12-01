Return-Path: <linux-kernel-owner+w=401wt.eu-S1754237AbXLAS2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbXLAS2u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 13:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbXLAS2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 13:28:35 -0500
Received: from mail.tmr.com ([64.65.253.246]:38217 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbXLAS2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 13:28:34 -0500
Message-ID: <4751AB91.2000207@tmr.com>
Date: Sat, 01 Dec 2007 13:44:33 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, linux-ide@vger.kernel.org,
       apiszcz@solarrain.com
Subject: Re: Kernel 2.6.23.9 / P35 Chipset + WD 750GB Drives (reset port)
References: <Pine.LNX.4.64.0712010619150.25643@p34.internal.lan> <Pine.LNX.4.64.0712011310410.30316@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0712011310410.30316@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Dec 1 2007 06:26, Justin Piszcz wrote:
>> I ran the following:
>>
>> dd if=/dev/zero of=/dev/sdc
>> dd if=/dev/zero of=/dev/sdd
>> dd if=/dev/zero of=/dev/sde
>>
>> (as it is always a very good idea to do this with any new disk)
> 
> Why would you care about what's on the disk? fdisk, mkfs and
> the day-to-day operation will overwrite it _anyway_.
> 
> (If you think the disk is not empty, you should look at it
> and copy off all usable warez beforehand :-)
> 
Do you not test your drive for minimum functionality before using them? 
Also, if you have the tools to check for relocated sectors before and 
after doing this, that's a good idea as well. S.M.A.R.T is your friend. 
And when writing /dev/zero to a drive, if it craps out you have less 
emotional attachment to the data.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
