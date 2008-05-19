Return-Path: <linux-kernel-owner+w=401wt.eu-S1758214AbYESNES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbYESNES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbYESNEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:04:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbYESNEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:04:07 -0400
Message-ID: <48317A72.701@redhat.com>
Date: Mon, 19 May 2008 09:02:42 -0400
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: 2.6.26-rc2-mm1 - machine stuck while booting up with CONFIG_FTRACE_STARTUP_TEST
 enabled
References: <20080514010129.4f672378.akpm@linux-foundation.org> <4831658F.2020306@linux.vnet.ibm.com>
In-Reply-To: <4831658F.2020306@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal wrote:
> Hi Andrew,
> 
> The 2.6.26-rc2-mm1 kernel gets stuck, while booting up on x86_64 machine,
> with the CONFIG_FTRACE_STARTUP_TEST enabled. The following .config
> options related to FTRACE are enabled. 
> 
> CONFIG_FTRACE_SELFTEST=y
> CONFIG_FTRACE_STARTUP_TEST=y
> CONFIG_FTRACE=y
> CONFIG_HAVE_FTRACE=y
> CONFIG_DYNAMIC_FTRACE=y
> 

[...]

> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1805035
> Policy zone: Normal
> Kernel command line: root=/dev/sda1 ro console=tty0 console=ttyS0,38400n1 noapci IDENT=1211176695

Hi, could you do nmi_watchdog=1 and see if that gives you a stack dump?

Thanks.

-- Steve

[...]

> checking if image is initramfs... it is
> Freeing initrd memory: 1466k freed
> audit: initializing netlink socket (disabled)
> type=2000 audit(1211176950.517:1): initialized
> Testing tracer sched_switch: PASSED
> Testing tracer sysprof: PASSED
> Testing tracer ftrace: 
> 

