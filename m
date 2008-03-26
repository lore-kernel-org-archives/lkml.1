Return-Path: <linux-kernel-owner+w=401wt.eu-S1759387AbYCZQ0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387AbYCZQ0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758421AbYCZQZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:25:52 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:32847 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758395AbYCZQZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:25:51 -0400
Date: Wed, 26 Mar 2008 17:25:50 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Tarkan Erimer <tarkan@netone.net.tr>
cc: alex-lists-linux-kernel@yuriev.com, linux-kernel@vger.kernel.org
Subject: Re: Visible boot slowdown between 2.6.24.3 and 2.6.22.2
In-Reply-To: <47EA03C8.8030806@netone.net.tr>
Message-ID: <alpine.LNX.1.10.0803261725270.22661@fbirervta.pbzchgretzou.qr>
References: <20080326024829.GA20476@s1.yuriev.com> <47EA03C8.8030806@netone.net.tr>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2008-03-26 09:05, Tarkan Erimer wrote:
> alex-lists-linux-kernel@yuriev.com wrote:
>>  Hi,
>>  	I saw a significant slowdown of a bootup time after 2.6.22.2 was
>>  upgraded to 2.6.24.3. Visibly I can see the issue when the boot process
>>  gets
>>  to running udev - now it sits for good minute or two. I can also visibly
>>  see
>>  a slowdown when I do "ps aux" under the new kernel vs. old one.
>>
>>  This is a relatively old system - 500 Mhz P3 Celeron with 512M RAM.
>>
>>  Any debugging suggestions are appreciated...
>> 
> It's the same for me,too. I tried 2.6.24.3 on my IBM R40, which has 1.4 GHZ 
> CPU, the boot process is very slow. I didn't run "ps aux". But, I'll try that 
> out and let know.

Please boot with printk.time=1 so that it is a bit easier to see where
it waits.
