Return-Path: <linux-kernel-owner+w=401wt.eu-S1759937AbYESOJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937AbYESOJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 10:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbYESOJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 10:09:26 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:37770 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbYESOJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 10:09:25 -0400
Message-ID: <483189C2.7050207@linux.vnet.ibm.com>
Date: Mon, 19 May 2008 19:38:02 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080505)
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: 2.6.26-rc2-mm1 - machine stuck while booting up with CONFIG_FTRACE_STARTUP_TEST
 enabled
References: <20080514010129.4f672378.akpm@linux-foundation.org> <4831658F.2020306@linux.vnet.ibm.com> <48317A72.701@redhat.com>
In-Reply-To: <48317A72.701@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> Kamalesh Babulal wrote:
>> Hi Andrew,
>>
>> The 2.6.26-rc2-mm1 kernel gets stuck, while booting up on x86_64 machine,
>> with the CONFIG_FTRACE_STARTUP_TEST enabled. The following .config
>> options related to FTRACE are enabled. 
>>
>> CONFIG_FTRACE_SELFTEST=y
>> CONFIG_FTRACE_STARTUP_TEST=y
>> CONFIG_FTRACE=y
>> CONFIG_HAVE_FTRACE=y
>> CONFIG_DYNAMIC_FTRACE=y
>>
> 
> [...]
> 
>> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1805035
>> Policy zone: Normal
>> Kernel command line: root=/dev/sda1 ro console=tty0 console=ttyS0,38400n1 noapci IDENT=1211176695
> 
> Hi, could you do nmi_watchdog=1 and see if that gives you a stack dump?
> 
> Thanks.
> 
> -- Steve

Hi Steven,

Passing nmi_watchdog=1 did not help in getting any extra information, over the previous
console log. The boot up message is stuck exactly at the same place.

> 
> [...]
> 
>> checking if image is initramfs... it is
>> Freeing initrd memory: 1466k freed
>> audit: initializing netlink socket (disabled)
>> type=2000 audit(1211176950.517:1): initialized
>> Testing tracer sched_switch: PASSED
>> Testing tracer sysprof: PASSED
>> Testing tracer ftrace: 
>>
> 

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
