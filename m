Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbYIYPRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbYIYPRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 11:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbYIYPRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 11:17:42 -0400
Received: from mail.tmr.com ([64.65.253.246]:51711 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbYIYPRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 11:17:41 -0400
Message-ID: <48DBAB81.8050900@tmr.com>
Date: Thu, 25 Sep 2008 11:17:21 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080716 Fedora/1.1.11-1.fc9 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Gwendal Grignou <gwendal@google.com>
CC: Justin Piszcz <jpiszcz@lucidpixels.com>,
       Brian Rademacher <rad@radfiles.net>, linux-ide@vger.kernel.org,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: exception Emask 0x0 SAct 0x1 / SErr 0x0 action 0x2 frozen
References: <3E6D0C24877245C3A5A327129A7B4CA7@909927SOSLA>	 <alpine.DEB.1.10.0809220404400.18908@p34.internal.lan>	 <5A4A9A3B0AAA4A20A33BC2D578F5F75F@909927SOSLA>	 <alpine.DEB.1.10.0809220828490.23159@p34.internal.lan>	 <5419A02543384E69AF2BA82FF6E66C14@909927SOSLA>	 <alpine.DEB.1.10.0809220903400.23159@p34.internal.lan>	 <4B1ABD0393EF40FFB0A12242FE8356AF@909927SOSLA>	 <alpine.DEB.1.10.0809220915470.23159@p34.internal.lan>	 <alpine.DEB.1.10.0809220926240.23159@p34.internal.lan> <e7510f760809231114y6cbaf13aqf7c63bd48a73c978@mail.gmail.com>
In-Reply-To: <e7510f760809231114y6cbaf13aqf7c63bd48a73c978@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gwendal Grignou wrote:
> About ata1:0 problem, as reported in the bugzilla bug: I would try to
> disable NCQ to see if it helps. Your disks firmware might not fully
> support it.
>
> You can either add the parameter "libata.force=noncq" when loading
> your kernel, or set queue_depth to 1 for all the Seagate drives behind
> the Marvell MV88SX6081 controller.
>
> About ata5:0 , someone - in user space probably - is trying to do a
> SMART ENABLE operation, but the device ignores it. I don't know which
> device you are using, but I assume it does not support ATA SMART
> feature set. Timeout is an acceptable but not a nice way to answer, a
> cancel would have been better; check if there is a firmware upgrade
> for your device.
>   

You certainly called the SMART issue, I was wondering why a new 
distribution install on some older hardware was getting all the errors, 
clearly the Fedora "smartd" doesn't check SMART capability before trying 
to enable the feature. Oddly the drive on which I see this does reply to 
SMART requests, so the firmware must be "semi-functional." Not a 
problem, in my case the drive is just used for testing handling of hot 
swap, and has no data of any value.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


