Return-Path: <linux-kernel-owner+w=401wt.eu-S933513AbYBNNd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513AbYBNNd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 08:33:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbYBNNdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 08:33:45 -0500
Received: from mail.bmlv.gv.at ([193.171.152.37]:49885 "EHLO mail.bmlv.gv.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933139AbYBNNdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 08:33:43 -0500
From: "Ph. Marek" <philipp.marek@bmlv.gv.at>
To: user-mode-linux-user@lists.sourceforge.net
Subject: Re: 2.6.24.2 won't compile UML
Date: Thu, 14 Feb 2008 14:33:29 +0100
User-Agent: KMail/1.9.7
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org
References: <200802141213.09859.philipp.marek@bmlv.gv.at>
In-Reply-To: <200802141213.09859.philipp.marek@bmlv.gv.at>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802141433.29839.philipp.marek@bmlv.gv.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,

On Donnerstag, 14. Februar 2008, Ph. Marek wrote:
> I'm trying to compile an UML binary from 2.6.24.
>
>   make ARCH=um O=... bzImage
>
> gives
>
>   make -C linux-2.6.24.2/ O=output_path/build ARCH=um bzImage
>   make[1]: Entering directory `output_path/linux-2.6.24.2'
>     GEN     output_path/build/Makefile
>   scripts/kconfig/conf -s arch/um/Kconfig
>   net/bluetooth/hidp/Kconfig:4:warning: 'select' used by config symbol 'BT_HIDP' refers to undefined symbol 'HID'

I now made a patch based on the spirit of 
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=0263603a01e802f79e369ac489793e5320031560
- although that's surely the wrong way to go, because it'll break
the other options. I just attach it in case other people have the same problem.


Now I get other errors ...
	$ make
	  CHK     include/linux/version.h
	  CHK     include/linux/utsrelease.h
	  CC      arch/x86/kernel/asm-offsets.s
	In file included from include/linux/sched.h:54,
	                 from arch/x86/kernel/asm-offsets_32.c:8,
	                 from arch/x86/kernel/asm-offsets.c:2:
	include/linux/jiffies.h:18:5: warning: "CONFIG_HZ" is not defined
	include/linux/jiffies.h:20:7: warning: "CONFIG_HZ" is not defined
	include/linux/jiffies.h:22:7: warning: "CONFIG_HZ" is not defined
	include/linux/jiffies.h:24:7: warning: "CONFIG_HZ" is not defined
	include/linux/jiffies.h:26:7: warning: "CONFIG_HZ" is not defined
	include/linux/jiffies.h:28:7: warning: "CONFIG_HZ" is not defined
	include/linux/jiffies.h:30:7: warning: "CONFIG_HZ" is not defined
	include/linux/jiffies.h:33:3: error: #error You lose.
and so on, and so on ...

I'm currently trying to use the pre-build binary from 
http://user-mode-linux.sourceforge.net - but I'd prefer to build
the kernel myself.


Help, please? Anyone?


Regards,

Phil
