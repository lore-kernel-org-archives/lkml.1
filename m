Return-Path: <linux-kernel-owner+w=401wt.eu-S965509AbXEHI4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965509AbXEHI4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 04:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934736AbXEHI4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 04:56:35 -0400
Received: from mail.syneticon.net ([213.239.212.131]:41510 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934730AbXEHI4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 04:56:34 -0400
Message-ID: <46403AF3.9000300@wpkg.org>
Date: Tue, 08 May 2007 10:55:15 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       netdev@vger.kernel.org, Michael Jones <mlj28@cam.ac.uk>,
       Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH] Intel IXP4xx network drivers v.2 - Ethernet and HSS
References: <464034CF.20700@wpkg.org> <f19298770705080148u70638ac2ue87241382681088@mail.gmail.com>
In-Reply-To: <f19298770705080148u70638ac2ue87241382681088@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Zaytsev schrieb:
> On 5/8/07, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
>> Michael Jones wrote:
>>
>> >> +#ifndef __ARMEB__
>> >> +#warning Little endian mode not supported
>> >> +#endif
>> >
>> > Personally I'm less fussed about WAN / LE support. Anyone with any
>> > sense will run ixp4xx boards doing such a specialised network
>> > operation as BE. Also, NSLU2-Linux can't test this functionality with
>> > our LE setup as we don't have this hardware on-board. You may just
>> > want to declare a depends on ARMEB in Kconfig (with or without OR
>> > (ARM || BROKEN) ) and have done with it - it's up to you.
>>
>> Christian Hohnstaedt's work did support LE though.
>>
>> Not all ixp4xx boards are by definition "doing such a specialised
>> network operation".
>>
> 
> I was always curious, why do people want to run ixp4xx in LE mode? What
> are the benefits that overweight the obvious performance degradation?

I guess the main reason, at least for me, is that there is only one 
distro that properly supports LE ARM: Debian.

It greatly simplifies management/administration of a higher number of 
devices, given the fact that Debian also supports other architectures 
(not just x86/64, sometimes PPC, like most distros do).


Not always network performance is to most important factor.


-- 
Tomasz Chmielewski
http://wpkg.org

