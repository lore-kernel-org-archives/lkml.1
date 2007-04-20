Return-Path: <linux-kernel-owner+w=401wt.eu-S2992893AbXDTPLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992893AbXDTPLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 11:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992923AbXDTPLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 11:11:49 -0400
Received: from bungunia.hst.terra.com.br ([200.176.10.196]:44886 "EHLO
	bungunia.hst.terra.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992893AbXDTPLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 11:11:48 -0400
X-Terra-Karma: -2%
X-Terra-Hash: bb8060abf7d074b7ddeea289078506b5
Message-ID: <4628D830.3020906@centralinf.com.br>
Date: Fri, 20 Apr 2007 12:11:44 -0300
From: guilherme <guilherme@centralinf.com.br>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc7: HPET enabled freeze my machine at boot
References: <4628B0DA.3070907@centralinf.com.br>	<p73mz133zr0.fsf@bingen.suse.de> <4628C045.3020503@centralinf.com.br> <p73irbr3ybm.fsf@bingen.suse.de>
In-Reply-To: <p73irbr3ybm.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

root@dub:/usr/src/linux-2.6# git bisect good
5d8b34fdcb384161552d01ee8f34af5ff11f9684 is first bad commit
commit 5d8b34fdcb384161552d01ee8f34af5ff11f9684
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Fri Feb 16 01:27:43 2007 -0800

     [PATCH] clocksource: Add verification (watchdog) helper

     The TSC needs to be verified against another clocksource.  Instead 
of using
     hardwired assumptions of available hardware, provide a generic 
verification
     mechanism.  The verification uses the best available clocksource 
and handles
     the usability for high resolution timers / dynticks of the 
clocksource which
     needs to be verified.

     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
     Signed-off-by: Ingo Molnar <mingo@elte.hu>
     Cc: john stultz <johnstul@us.ibm.com>
     Cc: Roman Zippel <zippel@linux-m68k.org>
     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

:040000 040000 62dc665aebadaa1bdb948959a718162b88e1ff68 
605d2b2d55e0b0edc4b26580d700f64fb878753a M      arch
:040000 040000 ce257f3585445396942b4bb35d4fd23c44ab4bb1 
5ace8e9bd9e9806ce468d7e8dec2db4f9052ed5e M      include
:040000 040000 dfca91fe8a0b3ee7de842b4dd3451220634516f1 
4c2ec00e90009d296f44f3e0b89c50e43336c6bc M      kernel
root@dub:/usr/src/linux-2.6#

Thanks.

Guilherme M. Schroeder
Network Administrator
Central de Vendas Informatica LTDA
Tel.: (11) 3665-2000 Ramal: 2008
http://www.centralinf.com.br


Andi Kleen wrote:
> guilherme <guilherme@centralinf.com.br> writes:
> 
>> With noapic it freezes too. This doesn't occur with 2.6.20.x thought.
> 
> Ah. Can you please git bisect it then? 
> 
> -Andi
> 
> 
