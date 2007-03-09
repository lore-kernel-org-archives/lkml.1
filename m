Return-Path: <linux-kernel-owner+w=401wt.eu-S1752610AbXCIInv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbXCIInv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 03:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbXCIInv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 03:43:51 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3910 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbXCIInu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 03:43:50 -0500
Date: Fri, 9 Mar 2007 08:43:40 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       sam@ravnborg.org
Subject: Re: [PATCH] Complain about missing system calls.
Message-ID: <20070309084340.GA29959@flint.arm.linux.org.uk>
Mail-Followup-To: David Woodhouse <dwmw2@infradead.org>, akpm@osdl.org,
	linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
	sam@ravnborg.org
References: <1173394873.3461.510.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173394873.3461.510.camel@pmac.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2007 at 11:01:13PM +0000, David Woodhouse wrote:
> Most system calls seem to get added to i386 first. This patch
> automatically generates a warning for any new system call which is
> implemented on i386 but not the architecture currently being compiled.
> On PowerPC at the moment, for example, it results in these warnings:
> init/missing_syscalls.h:935:3: warning: #warning syscall sync_file_range not implemented
> init/missing_syscalls.h:947:3: warning: #warning syscall getcpu not implemented
> init/missing_syscalls.h:950:3: warning: #warning syscall epoll_pwait not implemented
> 
> Signed-off-by: David Woodhouse <dwmw2@infradead.org>

You might also like to add:

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

since I did resolve the issues with getting a sed expression which
did the right thing, rather than your for loop, awk, echo, and
providing a way to ignore the lack of certain syscall numbers...

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
