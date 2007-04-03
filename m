Return-Path: <linux-kernel-owner+w=401wt.eu-S1422663AbXDCTv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422663AbXDCTv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 15:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422665AbXDCTv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 15:51:59 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:51260 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422663AbXDCTv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 15:51:59 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 3 Apr 2007 12:51:54 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc5-mm4
In-Reply-To: <20070403124854.7a5742e6.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0704031250440.23808@alien.or.mcafeemobile.com>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
 <20070403124854.7a5742e6.randy.dunlap@oracle.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007, Randy Dunlap wrote:

> On Mon, 2 Apr 2007 22:47:45 -0700 Andrew Morton wrote:
> 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/
> > 
> > - The oops in git-net.patch has been fixed, so that tree has been restored. 
> >   It is huge.
> > 
> > - Added the device-mapper development tree to the -mm lineup (Alasdair
> >   Kergon).  It is a quilt tree, living at
> >   ftp://ftp.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/.
> > 
> > - Added davidel's signalfd stuff.
>           ~~~~~~~~~~~~~~~~~~
> 
> with those new CONFIGs=n:  (we are discussing it)
> 
> arch/x86_64/kernel/built-in.o:(.rodata+0x18a8): undefined reference to `sys_signal
> fd'
> arch/x86_64/kernel/built-in.o:(.rodata+0x18b0): undefined reference to `sys_timerf
> d'
> arch/x86_64/kernel/built-in.o:(.rodata+0x18b8): undefined reference to `sys_eventf
> d'
> arch/x86_64/ia32/ia32entry.S:(.rodata+0xa08): undefined reference to `sys_signalfd
> '
> arch/x86_64/ia32/ia32entry.S:(.rodata+0xa10): undefined reference to `sys_timerfd'
> arch/x86_64/ia32/ia32entry.S:(.rodata+0xa18): undefined reference to `sys_eventfd'
> make: *** [.tmp_vmlinux1] Error 1

I'll be sending Andrew patches against -mm4. The ones that fix the above, 
and the one for the include-files diet.



- Davide


