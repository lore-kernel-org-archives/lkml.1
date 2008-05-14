Return-Path: <linux-kernel-owner+w=401wt.eu-S1761274AbYENLYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761274AbYENLYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 07:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756542AbYENLYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 07:24:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:47109 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721AbYENLYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 07:24:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=fjp7AlkNVWPuVlU3hBo4T98LG9LyqLuDtaZaU34xyGr4rin7z1T/8u+fsv9qyPlmkExxOSZ0Qt2OvApmO06z8HGI5OCYSJSmRPjoJH3JAIy+pXZHSO/IPjlYl3kYaIU6FN4ORIfYSbETq7B1LBhmWBXIpi1hNr79Qg3BgW/Nylg=
Date: Wed, 14 May 2008 19:22:17 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: toralf.foerster@gmx.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: UML build issue with v2.6.26-rc2-129-g9604006
Message-ID: <20080514112217.GC2520@hacking>
References: <200805141301.30027.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805141301.30027.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 01:01:27PM +0200, =?ISO-8859-1?Q?Toralf_F=F6rster_ wrote:
>Today I got:
>
>...
>  CC      arch/um/os-Linux/skas/process.o
>  LD      arch/um/os-Linux/skas/built-in.o
>  CC      arch/um/os-Linux/sys-i386/registers.o
>arch/um/os-Linux/sys-i386/registers.c:8:22: error: asm/user.h: No such file or directory
>arch/um/os-Linux/sys-i386/registers.c: In function 'arch_init_registers':
>arch/um/os-Linux/sys-i386/registers.c:78: error: storage size of 'fpx_regs' isn't known
>arch/um/os-Linux/sys-i386/registers.c:78: warning: unused variable 'fpx_regs'
>make[2]: *** [arch/um/os-Linux/sys-i386/registers.o] Error 1
>make[1]: *** [arch/um/os-Linux/sys-i386] Error 2
>make: *** [arch/um/os-Linux] Error 2


Hmm, it seems that I can't reproduce it with your .config.
And <asm/user.h> does exist.

Have you used 'ARCH=um' when you ran 'make'? If not, please try it.

Thanks!
