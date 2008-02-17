Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbYBQAEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbYBQAEh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 19:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbYBQAEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 19:04:30 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:52956 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbYBQAE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 19:04:29 -0500
Date: Sun, 17 Feb 2008 01:04:28 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Rob Landley <rob@landley.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: Compiling with 2.6.25-rc2 with binutils 2.17 fails?
In-Reply-To: <200802161727.21312.rob@landley.net>
Message-ID: <Pine.LNX.4.64.0802170103420.25183@fbirervta.pbzchgretzou.qr>
References: <200802161727.21312.rob@landley.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 16 2008 17:27, Rob Landley wrote:
>The build does this:
>>   VDSOSYM arch/x86/vdso/vdso32-syms.lds
>> --- -   Fri Feb 15 23:38:41 2008
>> +++ arch/x86/vdso/vdso32-int80-syms.lds Fri Feb 15 23:38:41 2008
>> @@ -0,0 +1,5 @@
>> +VDSO32_PRELINK = 0x0;
>> +VDSO32_rt_sigreturn = 0x040c;
>> +VDSO32_sigreturn = 0x0400;
>> +VDSO32_vsyscall = 0x0414;
>> +VDSO32_vsyscall_eh_frame_size = 0x040;
>> make[1]: *** [arch/x86/vdso/vdso32-syms.lds] Error 1
>> make: *** [arch/x86/vdso] Error 2
>> make: *** Waiting for unfinished jobs....
>
>Still trying to track down why, but it works on a toolchain built from 
>binutils 2.18 and gcc 4.1.3, but not with a toolchain from binutils 2.17 and 
>gcc 4.1.2.  And considering where it's failing...
>
>If binutils 2.18 is the only version that now builds the kernel, could we 
>update Documentaiton/Changes to say that instead of 2.12?

I have, as part of opensuse, binutils 2.17.50 and gcc 4.2.1 and that 
works fine.
