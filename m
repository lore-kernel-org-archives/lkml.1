Return-Path: <linux-kernel-owner+w=401wt.eu-S932848AbXBYAcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848AbXBYAcO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 19:32:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932789AbXBYAcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 19:32:14 -0500
Received: from mailgw.cvut.cz ([147.32.3.235]:43993 "EHLO mailgw.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932848AbXBYAcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 19:32:14 -0500
Message-ID: <45E0D8F7.9050803@vc.cvut.cz>
Date: Sat, 24 Feb 2007 16:31:51 -0800
From: Petr Vandrovec <vandrove@vc.cvut.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20061219 Iceape/1.0.7 (Debian-1.0.7-3)
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Chris Rankin <rankincj@yahoo.com>, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel warning from Matrox Framebuffer in 2.6.20.1
References: <306590.53720.qm@web52912.mail.yahoo.com> <200702241818.24675.linux@rainbow-software.org>
In-Reply-To: <200702241818.24675.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ondrej Zary wrote:
> On Saturday 24 February 2007 14:08, Chris Rankin wrote:
>> Hi,
>>
>> I have just booted 2.6.20.1 on my Pentium 3 machine, which has a G400 MAX
>> graphics card. This machine uses the Matrox framebuffer and TV-OUT modules,
>> and I have found these warnings in the kernel log:
>>
>> **WARNING** I2C adapter driver [DDC:fb0 #0] forgot to specify physical
>> device; fix it! **WARNING** I2C adapter driver [DDC:fb0 #1] forgot to
>> specify physical device; fix it! **WARNING** I2C adapter driver [MAVEN:fb0]
>> forgot to specify physical device; fix it!
> 
> I'm seeing something like that since installing 2.6.20.1 yesterday:
> 
> matroxfb: Matrox Mystique (PCI) detected
> PInS memtype = 0
> matroxfb: MTRR's turned on
> matroxfb: 1024x768x8bpp (virtual: 1024x4096)
> matroxfb: framebuffer at 0xE1000000, mapped to 0xcc880000, size 4194304
> Console: switching to colour frame buffer device 128x48
> fb0: MATROX frame buffer device
> **WARNING** I2C adapter driver [DDC:fb0 #0] forgot to specify physical device; 
> fix it!

Can you try current git tree?  I believe that it is already fixed by 
Jean Delvare checkin from Feb 13th (thanks Jean!)
							Petr


