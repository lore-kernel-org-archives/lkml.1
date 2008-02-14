Return-Path: <linux-kernel-owner+w=401wt.eu-S932486AbYBNONR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486AbYBNONR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 09:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755002AbYBNONF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 09:13:05 -0500
Received: from fonzie.hosting9000.com ([85.214.50.12]:44010 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904AbYBNONE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 09:13:04 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Feb 2008 09:13:03 EST
Message-ID: <47B44ADA.9020103@frugalware.org>
Date: Thu, 14 Feb 2008 15:06:18 +0100
From: Gabriel C <crazy@frugalware.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071204)
MIME-Version: 1.0
To: "Ph. Marek" <philipp.marek@bmlv.gv.at>
CC: user-mode-linux-user@lists.sourceforge.net, jdike@addtoit.com,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24.2 won't compile UML
References: <200802141213.09859.philipp.marek@bmlv.gv.at> <200802141433.29839.philipp.marek@bmlv.gv.at>
In-Reply-To: <200802141433.29839.philipp.marek@bmlv.gv.at>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ph. Marek wrote:
> Hello everybody,

Hi,

> 
> On Donnerstag, 14. Februar 2008, Ph. Marek wrote:
>> I'm trying to compile an UML binary from 2.6.24.
>>
>>   make ARCH=um O=... bzImage
>>
>> gives
>>
>>   make -C linux-2.6.24.2/ O=output_path/build ARCH=um bzImage
>>   make[1]: Entering directory `output_path/linux-2.6.24.2'
>>     GEN     output_path/build/Makefile
>>   scripts/kconfig/conf -s arch/um/Kconfig
>>   net/bluetooth/hidp/Kconfig:4:warning: 'select' used by config symbol 'BT_HIDP' refers to undefined symbol 'HID'
> 
> I now made a patch based on the spirit of 
>   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=0263603a01e802f79e369ac489793e5320031560
> - although that's surely the wrong way to go, because it'll break
> the other options. I just attach it in case other people have the same problem.
> 
> 
> Now I get other errors ...
> 	$ make
> 	  CHK     include/linux/version.h
> 	  CHK     include/linux/utsrelease.h
> 	  CC      arch/x86/kernel/asm-offsets.s
> 	In file included from include/linux/sched.h:54,
> 	                 from arch/x86/kernel/asm-offsets_32.c:8,
> 	                 from arch/x86/kernel/asm-offsets.c:2:
> 	include/linux/jiffies.h:18:5: warning: "CONFIG_HZ" is not defined
> 	include/linux/jiffies.h:20:7: warning: "CONFIG_HZ" is not defined
> 	include/linux/jiffies.h:22:7: warning: "CONFIG_HZ" is not defined
> 	include/linux/jiffies.h:24:7: warning: "CONFIG_HZ" is not defined
> 	include/linux/jiffies.h:26:7: warning: "CONFIG_HZ" is not defined
> 	include/linux/jiffies.h:28:7: warning: "CONFIG_HZ" is not defined
> 	include/linux/jiffies.h:30:7: warning: "CONFIG_HZ" is not defined
> 	include/linux/jiffies.h:33:3: error: #error You lose.
> and so on, and so on ...
> 

Your tree is most probably broken. make mrproper and try building again. 

> Regards,
> 
> Phil

Gabriel
