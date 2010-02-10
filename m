Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab0BJSrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 13:47:45 -0500
Received: from claw.goop.org ([74.207.240.146]:50323 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756381Ab0BJSro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 13:47:44 -0500
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Feb 2010 13:47:44 EST
Message-ID: <4B72FD09.1020202@goop.org>
Date: Wed, 10 Feb 2010 10:38:01 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Jeremy Fitzhardinge <jeremy@xensource.com>, virtualization@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Paravirt compile failure with gcc33
References: <alpine.LSU.2.01.1002101909560.29808@obet.zrqbmnf.qr>
In-Reply-To: <alpine.LSU.2.01.1002101909560.29808@obet.zrqbmnf.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2010 10:13 AM, Jan Engelhardt wrote:
> As I was compile-testing 2.6.33-rc with gcc-3.3,
> binutils-2.19.51-10.26.4.x86_64, I observed a failure when
> CONFIG_PARAVIRT is turned on:
>    

Yeah, there's a gcc bug of some kind there, and its very hard to see how 
to work around it.  When we last discussed this, I think we were close 
to deciding to obsolete gcc 3.3.

HPA, do you remember?

     J

>
> [any file]
> /home/jengelh/code/linux/arch/x86/include/asm/paravirt.h: In function
> `rif_seq_stop':
> /home/jengelh/code/linux/arch/x86/include/asm/paravirt.h:763: warning:
> asm operand 5 probably doesn't match constraints
> /home/jengelh/code/linux/arch/x86/include/asm/paravirt.h:858: warning:
> asm operand 2 probably doesn't match constraints
> /home/jengelh/code/linux/arch/x86/include/asm/paravirt.h:763: error:
> impossible constraint in `asm'
> /home/jengelh/code/linux/arch/x86/include/asm/paravirt.h:858: error:
> impossible constraint in `asm'
>
> Disabling either PARAVIRT or using GCC4.x works around this.
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/virtualization
>
>    

