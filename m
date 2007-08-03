Return-Path: <linux-kernel-owner+w=401wt.eu-S1760212AbXHCCSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760212AbXHCCSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 22:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756319AbXHCCSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 22:18:39 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:24930 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbXHCCSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 22:18:38 -0400
X-IronPort-AV: i="4.19,215,1183348800"; 
   d="scan'208"; a="47266123:sNHT26169738"
Subject: Re: blackfin toolchain and build issues
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Bryan Wu <bryan.wu@analog.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <20070802194405.GB3646@uranus.ravnborg.org>
References: <20070729223613.GA5916@martell.zuzino.mipt.ru>
	 <alpine.LFD.0.999.0707291706490.3442@woody.linux-foundation.org>
	 <1185770527.22473.2.camel@roc-desktop>
	 <20070730194335.GE5776@martell.zuzino.mipt.ru>
	 <1185850297.20043.6.camel@roc-desktop>
	 <20070802194405.GB3646@uranus.ravnborg.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Fri, 03 Aug 2007 10:18:01 +0800
Message-Id: <1186107481.6131.2.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 03 Aug 2007 02:18:36.0688 (UTC) FILETIME=[99386100:01C7D574]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-02 at 21:44 +0200, Sam Ravnborg wrote:
> > > 
> > Oh, do you need use blackfin toolchain? Actually, it is very simple to
> > setup it on your machine.
> > please get the latest binary toolchain here:
> > http://blackfin.uclinux.org/gf/download/frsrelease/344/3180/blackfin-toolchain-uclinux-SVN.tar.bz2
> > http://blackfin.uclinux.org/gf/download/frsrelease/344/3181/blackfin-toolchain-linux-uclibc-SVN.tar.bz2
> 
> Thanks - installed.
> 
> While building latest git tree I see several 'funny' errors.
>   LD      kernel/built-in.o
> bfin-linux-uclibc-ld: Warning: size of symbol `_sys_futex' changed from 4 in kernel/sys_ni.o to 262 in kernel/futex.o
> bfin-linux-uclibc-ld: Warning: size of symbol `_sys_set_robust_list' changed from 4 in kernel/sys_ni.o to 30 in kernel/futex.o
> bfin-linux-uclibc-ld: Warning: size of symbol `_sys_get_robust_list' changed from 4 in kernel/sys_ni.o to 170 in kernel/futex.o
> bfin-linux-uclibc-ld: Warning: size of symbol `_sys_setfsgid16' changed from 4 in kernel/sys_ni.o to 16 in kernel/uid16.o
> bfin-linux-uclibc-ld: Warning: size of symbol `_sys_setfsuid16' changed from 4 in kernel/sys_ni.o to 16 in kernel/uid16.o
> bfin-linux-uclibc-ld: Warning: size of symbol `_sys_setresgid16' changed from 4 in kernel/sys_ni.o to 36 in kernel/uid16.o
> bfin-linux-uclibc-ld: Warning: size of symbol `_sys_setresuid16' changed from 4 in kernel/sys_ni.o to 36 in kernel/uid16.o
> bfin-linux-uclibc-ld: Warning: size of symbol `_sys_setuid16' changed from 4 in kernel/sys_ni.o to 16 in kernel/uid16.o
> bfin-linux-uclibc-ld: Warning: size of symbol `_sys_setreuid16' changed from 4 in kernel/sys_ni.o to 26 in kernel/uid16.o
> ...
> 
> and later:
> 
>   LD      .tmp_vmlinux1
> bfin-linux-uclibc-ld: Warning: size of symbol `_sys_mremap' changed from 4 in kernel/built-in.o to 82 in mm/built-in.o
> bfin-linux-uclibc-ld: Warning: size of symbol `_sys_ioprio_set' changed from 4 in kernel/built-in.o to 362 in fs/built-in.o
> bfin-linux-uclibc-ld: Warning: size of symbol `_sys_epoll_wait' changed from 4 in kernel/built-in.o to 1002 in fs/built-in.o
> bfin-linux-uclibc-ld: Warning: size of symbol `_sys_timerfd' changed from 4 in kernel/built-in.o to 346 in fs/built-in.o
> bfin-linux-uclibc-ld: Warning: size of symbol `_sys_ioprio_get' changed from 4 in kernel/built-in.o to 344 in fs/built-in.o
> 
> 

I will check this on my side ASAP.  But the git-tree did not merge my
"fs.h" header file patch, how could it compiled passed like this?

> 
> I did not look into these. I assume it is a toolchain issue??
> 
> PS. I had to fix a few things to get so far but as I did not do
> it the right way I have no patch.
> 
> 	Sam

Thanks
