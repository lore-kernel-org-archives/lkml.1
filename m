Return-Path: <linux-kernel-owner+w=401wt.eu-S1752199AbXCSTSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbXCSTSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 15:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382AbXCSTSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 15:18:40 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:13274 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbXCSTSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 15:18:39 -0400
Date: Mon, 19 Mar 2007 12:17:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, gregkh <greg@kroah.com>
Subject: Re: 2.6.21-rc3-mm2
Message-Id: <20070319121724.2360a610.randy.dunlap@oracle.com>
In-Reply-To: <20070307201915.4d579113.akpm@linux-foundation.org>
References: <20070307201915.4d579113.akpm@linux-foundation.org>
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

On Wed, 7 Mar 2007 20:19:15 -0800 Andrew Morton wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc3/2.6.21-rc3-mm2/
> 
> - This is the same as 2.6.21-rc3-mm1, except Con's CPU scheduler changes
>   were dropped.
> 
>   This is for A/B comparison purposes, and because those changes crashed on
>   one test setup.

x86_64, with CONFIG_HOTPLUG disabled:

drivers/base/bus.c: In function 'store_drivers_probe':
drivers/base/bus.c:747: error: 'driver_helper' undeclared (first use in this function)
drivers/base/bus.c:747: error: (Each undeclared identifier is reported only once
drivers/base/bus.c:747: error: for each function it appears in.)
make[2]: *** [drivers/base/bus.o] Error 1
make[1]: *** [drivers/base] Error 2
make: *** [drivers] Error 2


> Changes since 2.6.21-rc3-mm1:
> 
> -lists-add-list-splice-tail.patch
> -sched-remove-sleepavg-from-proc.patch
> -sched-remove-noninteractive-flag.patch
> -sched-implement-180-bit-sched-bitmap.patch
> -sched-implement-rsdl-cpu-scheduler.patch
> -sched-document-rsdl-cpu-scheduler.patch
> 
>  Removed.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
