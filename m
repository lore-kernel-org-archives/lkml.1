Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710AbZHLClL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbZHLClL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 22:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbZHLClK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 22:41:10 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:57239 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824AbZHLClJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 22:41:09 -0400
Message-ID: <4A822BBD.1080409@qi-hardware.com>
Date: Wed, 12 Aug 2009 10:41:01 +0800
From: Xiangfu Liu <xiangfu@qi-hardware.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "Hard- and Software Development, Kernel, Distribution, Roadmap" 
	<developer@lists.qi-hardware.com>,
       linux-kernel@vger.kernel.org
Subject: Re: qi_lb60_keypad driver question?
References: <4A819D39.2040006@qi-hardware.com> <20090812024620.E4E10526EC9@mailhub.coreip.homeip.net>
In-Reply-To: <20090812024620.E4E10526EC9@mailhub.coreip.homeip.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry Torokhow

thanks for the reply.

Dmitry Torokhov wrote:
> Which is not telling most of the people anything. For example I have no
> idea whta .25 kernel is.
>   
we are current work on 2.6.25.20 kernel. make it work in 'Ben NanoNote' [1]
all the patch is at [2]
> There is already an updated version of matrix_keypad driver in mainline,
> you don't need to repost it.
> This should go into arch specific board setup code, not in drivers/input
>
>   
>> +
>> +static struct platform_device qi_lb60_device = {
>> +	.name		= "qi_lb60-keyboard",
>> +	.name		= "matrix-keypad",
>>     
>
> You are setting .name twice. Also, statically allocated platform devices
> may not be unregistered. Just create this device once in your board init
> code instead of having a separate unloadable module.
>   
thanks for the info.

[1]http://www.qi-hardware.com/products/ben-nanonote/
[2]http://github.com/lindnermarek/openwrt-x-burst/tree/adb28f982f25a822d2dda9aa054470f3fff02908/target/linux/xburst/patches-2.6.25
--
Xiangfu Liu 刘向富
==================================
Qi Hardware Inc.
Mobile: +86 132 4141 2371
Jabber: xiangfu.z at gmail.com
Email : xiangfu at qi-hardware.com
Web   : http://www.qi-hardware.com
==================================

