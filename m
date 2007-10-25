Return-Path: <linux-kernel-owner+w=401wt.eu-S1759719AbXJYDAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759719AbXJYDAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 23:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbXJYDAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 23:00:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32947 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758093AbXJYDAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 23:00:37 -0400
Date: Wed, 24 Oct 2007 19:57:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-arm-kernel@lists.arm.linux.org.uk,
       Russell King <rmk@arm.linux.org.uk>,
       Bill Gatliff <bgat@billgatliff.com>
Cc: bugme-daemon@bugzilla.kernel.org, svs1957@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 9217] New: CONFIG_CMDLINE doesn't pass to
 kernel
Message-Id: <20071024195717.0de6a248.akpm@linux-foundation.org>
In-Reply-To: <bug-9217-10286@http.bugzilla.kernel.org/>
References: <bug-9217-10286@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 05:32:14 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=9217
> 
>            Summary: CONFIG_CMDLINE doesn't pass to kernel
>            Product: Other
>            Version: 2.5
>      KernelVersion: 2.6.23
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: Other
>         AssignedTo: other_other@kernel-bugs.osdl.org
>         ReportedBy: svs1957@gmail.com
> 
> 
> Most recent kernel where this bug did not occur:2.6.24-rc1
> Distribution: Debian Armel (arm with EABI)
> Hardware Environment: Sharp Zaurus 750 (ARM pxa255)
> Software Environment: Debian
> Problem Description:
> I try to upgrade kernel from 2.6.22.9 to 2.6.23.
> 2.6.22.9 works correct. Kernel 2.6.23 doesn't use  CONFIG_CMDLINE and doesn't
> pass bootparams:
> CONFIG_CMDLINE="console=ttyS0,115200n8 console=tty1 noinitrd
> root=/dev/mmcblk0p1 rootfstype=ext3 rw rootdelay=5"
> But kernel still try to mount /dev/mtdblock2 using jffs2.
> Steps to reproduce:
> Compile kernel with CONFIG_CMDLINE and try to boot.
> 
> 

Something broke CONFIG_CMDLINE of ARM (at least) between 2.6.22 and 2.6.23.

I don't know whether it was an ARM patch one of those kernel-wide changes. 
We have futzed with the command-line parsing a bit recently, but the 2.6.23
changelog doesn't suggest anything obvious.

