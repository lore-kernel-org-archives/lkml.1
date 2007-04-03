Return-Path: <linux-kernel-owner+w=401wt.eu-S1422662AbXDCTso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422662AbXDCTso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 15:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422664AbXDCTso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 15:48:44 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:53825 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422662AbXDCTsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 15:48:43 -0400
Date: Tue, 3 Apr 2007 12:48:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, davidel@xmailserver.org
Subject: Re: 2.6.21-rc5-mm4
Message-Id: <20070403124854.7a5742e6.randy.dunlap@oracle.com>
In-Reply-To: <20070402224745.71a25af7.akpm@linux-foundation.org>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2007 22:47:45 -0700 Andrew Morton wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/
> 
> - The oops in git-net.patch has been fixed, so that tree has been restored. 
>   It is huge.
> 
> - Added the device-mapper development tree to the -mm lineup (Alasdair
>   Kergon).  It is a quilt tree, living at
>   ftp://ftp.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/.
> 
> - Added davidel's signalfd stuff.
          ~~~~~~~~~~~~~~~~~~

with those new CONFIGs=n:  (we are discussing it)

arch/x86_64/kernel/built-in.o:(.rodata+0x18a8): undefined reference to `sys_signal
fd'
arch/x86_64/kernel/built-in.o:(.rodata+0x18b0): undefined reference to `sys_timerf
d'
arch/x86_64/kernel/built-in.o:(.rodata+0x18b8): undefined reference to `sys_eventf
d'
arch/x86_64/ia32/ia32entry.S:(.rodata+0xa08): undefined reference to `sys_signalfd
'
arch/x86_64/ia32/ia32entry.S:(.rodata+0xa10): undefined reference to `sys_timerfd'
arch/x86_64/ia32/ia32entry.S:(.rodata+0xa18): undefined reference to `sys_eventfd'
make: *** [.tmp_vmlinux1] Error 1

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
