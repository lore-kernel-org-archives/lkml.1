Return-Path: <linux-kernel-owner+w=401wt.eu-S1758464AbZAHPUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464AbZAHPUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 10:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755164AbZAHPT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 10:19:58 -0500
Received: from nlpi012.sbcis.sbc.com ([207.115.36.41]:59866 "EHLO
	nlpi012.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbZAHPT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 10:19:57 -0500
Message-ID: <49661B0F.6030206@softplc.com>
Date: Thu, 08 Jan 2009 09:26:07 -0600
From: Dick Hollenbeck <dick@softplc.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: New true IDE compact flash driver starting point?
References: <49659E41.5070001@softplc.com> <200901081318.44188.arnd@arndb.de>
In-Reply-To: <200901081318.44188.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Thursday 08 January 2009, Dick Hollenbeck wrote:
>   
>> On a new ARM9 board with memory mapped interface to a compact flash 
>> socket, I need to implement an IDE or ATA driver that will support TRUE 
>> IDE mode.
>>
>> Am using kernel version 2.6.26
>>
>> What is the best starting point, i.e. example driver in the tree?
>>     
>
> You should not need to write a new driver, but rather use the existing
> drivers/ata/pata_platform.c driver by registering the MMIO registers
> and IRQ number as a platform device.
>
> 	Arnd <><
>   
Thank you Arnd!

Is there some example code in the tree to do this?

I've done something similar to this for 8250 serial ports, but I am 
having a difficult time finding out how to do this with pata_platform.c

Thanks,

Dick Hollenbeck


