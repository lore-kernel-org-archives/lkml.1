Return-Path: <linux-kernel-owner+w=401wt.eu-S1761619AbXHFCbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761619AbXHFCbh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 22:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbXHFCba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 22:31:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:33967 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179AbXHFCb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 22:31:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,223,1183359600"; 
   d="scan'208";a="275035683"
Subject: Re: [PATH 0/1] Kexec jump - v2 - the first step to kexec based
	hibernation
From: "Huang, Ying" <ying.huang@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, david@lang.hm,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20070805185558.GE1758@elf.ucw.cz>
References: <1184483593.1898.98.camel@caritas-dev.intel.com>
	 <20070731110458.GA1777@elf.ucw.cz>
	 <1185932071.1363.13.camel@caritas-dev.intel.com>
	 <20070805185558.GE1758@elf.ucw.cz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 06 Aug 2007 10:31:26 +0800
Message-Id: <1186367486.527.5.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 06 Aug 2007 02:31:21.0340 (UTC) FILETIME=[E03A43C0:01C7D7D1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-08-05 at 20:55 +0200, Pavel Machek wrote:
> Did the trick, I got the kernel to load, and it even attempted
> exec... but I got doublefault (or what is it?)
> 
> Int 6: ... EIP: c4739906. Address is in reserve_bootmem_core.
> 
> Do I have to disable ACPI completely? I tried with acpi=off,
> nosmp... but problem does not seem device related.

It seems that the problem has nothing to do with device or ACPI. Can you
do a normal kexec? That is:

kexec -l <...>
kexec -e

or 

kexec -p <...>
ALT-SysRq-c to trigger a crash dump.

Best Regards,
Huang Ying
