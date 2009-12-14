Return-Path: <linux-kernel-owner+w=401wt.eu-S1755812AbZLNKEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbZLNKEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 05:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755524AbZLNKEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 05:04:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:51238 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469AbZLNKEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 05:04:23 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the limits tree with Linus' tree
Date: Mon, 14 Dec 2009 11:04:04 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>
References: <20091214143917.f5b90e15.sfr@canb.auug.org.au>
In-Reply-To: <20091214143917.f5b90e15.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912141104.04738.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1++ofyp9LelMiBf8YVVf7+x2ptv/4cpNcHCJeu
 jkGG5b34an1x+1wQKVbFi96UuxTrz/542wyAsPLONtK8Ap+7oB
 7WEETNWkERZec1MFpBk1w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 December 2009, Stephen Rothwell wrote:
> @@@ -622,13 -622,13 +622,17 @@@ __SYSCALL(__NR_move_pages, sys_move_pag
>   __SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
>   #define __NR_perf_event_open 241
>   __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
>  -#define __NR_getprlimit 242
>  +#define __NR_accept4 242
>  +__SYSCALL(__NR_accept4, sys_accept4)
>  +#define __NR_recvmmsg 243
>  +__SYSCALL(__NR_recvmmsg, sys_recvmmsg)
> ++#define __NR_getprlimit 244
> + __SYSCALL(__NR_getprlimit, sys_getprlimit)
>  -#define __NR_setprlimit 243
> ++#define __NR_setprlimit 245
> + __SYSCALL(__NR_setprlimit, sys_setprlimit)
>   
>   #undef __NR_syscalls
> --#define __NR_syscalls 244
> ++#define __NR_syscalls 246

Looks good.

	Arnd
