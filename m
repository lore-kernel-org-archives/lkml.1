Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbZCCUrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbZCCUrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 15:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbZCCUrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 15:47:40 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:49928 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbZCCUrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 15:47:40 -0500
Message-ID: <49AD97BF.3050909@oracle.com>
Date: Tue, 03 Mar 2009 12:49:03 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Justin Mattock <justinmattock@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: scripts/unifdef.c:209: error: conflicting types for 'getline'
References: <dd18b0c30903031236t6ed1adaen64507b0ab4be34a4@mail.gmail.com>
In-Reply-To: <dd18b0c30903031236t6ed1adaen64507b0ab4be34a4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A01020A.49AD9765.0021:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Mattock wrote:
> Hello;
> I am unable to compile the kernel
> (just did a git pull a few minuets ago);
> here is what I see:
> 
> WARNING: modpost: Found 1 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
>   KSYM    .tmp_kallsyms1.S
>    AS      .tmp_kallsyms1.o
>   LD      .tmp_vmlinux2
>   KSYM    .tmp_kallsyms2.S
>   AS      .tmp_kallsyms2.o
>   CHK     include/linux/version.h
>   HOSTCC  scripts/unifdef
> scripts/unifdef.c:209: error: conflicting types for 'getline'
> /usr/include/stdio.h:651: note: previous declaration of 'getline' was here
> make[2]: *** [scripts/unifdef] Error 1
> make[1]: *** [__headers] Error 2
> make: *** [vmlinux] Error 2
> 
> The only change to .config was:
> 
> SYSFS_DEPRECATED_V2 [=y]
> to
> SYSFS_DEPRECATED_V2 [=n]
> to see if I can make udev from:
> 
> udev: starting version 137
> [    7.557317] udev: deprecated sysfs layout; update the kernel or disable
> CONFIG_SYSFS_DEPRECATED; some udev features will not work correctly
> 
> giving me this message.
> 
> also I did use a CFLAGS when compiling,
> but never received this when doing so for:
> 2.6.29-rc5-00289-g460c133
> 
> any info would be appreciated.

What CFLAGS?  I can't reproduce the problem.


-- 
~Randy
