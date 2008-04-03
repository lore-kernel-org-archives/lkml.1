Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbYDCXSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbYDCXSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 19:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbYDCXSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 19:18:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751519AbYDCXSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 19:18:21 -0400
Date: Thu, 3 Apr 2008 16:17:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com
Subject: Re: 2.6.25-rc8-mm1: Intel SATA boot failure
Message-Id: <20080403161733.c05dac53.akpm@linux-foundation.org>
In-Reply-To: <47F56363.4090002@imap.cc>
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org>
	<47F56363.4090002@imap.cc>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Apr 2008 01:08:19 +0200
Tilman Schmidt <tilman@imap.cc> wrote:

> Andrew Morton schrieb:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm1/
> 
> This fails to come up on my development machine, apparently because it
> has trouble accessing the SATA hard disks.
> Hardware: Intel Pentium D940, Intel DQ965GF board, two SATA hard disks.
> Some unusual things I noticed during the boot process:
> 
> - a message "doing fast boot" that looked unfamiliar; unfortunately
>   it scrolled off too quickly to note its context
> 
> - for each of the two SATA ports in use, a message
>   "SATA port is slow to respond, please be patient"
>   accompanied by about 10 secs wait
> 
> - it actually got past the point where it mounts the root file system,
>   so it must have thought it could access the disks
> 
> - finally, the system hung completely after the SUSE startup messages
> 
>   Setting current sysctl status from /etc/sysctl.conf
>   net.ipv4.icmp_echo_ignore_broadcasts = 1
> 
>   with a dead keyboard and I had to hit the Win^Wreset button.
> 
> - After rebooting into 2.6.24-rc8 (which works fine), nothing had been
>   written to the disks, not even the dmesg output which SUSE usually
>   dumps into /var/log/boot.msg early during startup.
> 
> Before I try booting that kernel again, any instructions on what to
> watch out for? Is netconsole usable again?

Yes, netconsole is usable again ;)

> Other ideas?

Usual stuff: `diff -u dmesg-2.6.25-rc8 dmesg-2.6.25-rc8-mm1'.  Bisection.

Thanks.
