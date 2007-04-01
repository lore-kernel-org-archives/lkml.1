Return-Path: <linux-kernel-owner+w=401wt.eu-S933666AbXDARTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933666AbXDARTK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 13:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933629AbXDARTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 13:19:10 -0400
Received: from smtpa2.netcabo.pt ([212.113.174.17]:6260 "EHLO
	exch01smtp01.hdi.tvcabo" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933666AbXDARTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 13:19:09 -0400
Message-ID: <460FE7F3.4060303@rncbc.org>
Date: Sun, 01 Apr 2007 18:12:19 +0100
From: Rui Nuno Capela <rncbc@rncbc.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-rt-users@vger.kernel.org
Subject: 2.6.21-rc5-rt6 make errors
References: <23932.213.58.131.130.1170156409.squirrel@www.rncbc.org>
In-Reply-To: <23932.213.58.131.130.1170156409.squirrel@www.rncbc.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Apr 2007 17:19:06.0936 (UTC) FILETIME=[DA88F380:01C77481]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just tried to build 2.6.21-rc5-rt6 and it is failing on build time.

...
kernel/sched.c: In function ‘__schedule’:
kernel/sched.c:3830: error: ‘print_functions’ undeclared (first use in
this function)
kernel/sched.c:3830: error: (Each undeclared identifier is reported only
once
kernel/sched.c:3830: error: for each function it appears in.)
...
arch/i386/kernel/apic.c: In function ‘smp_apic_timer_interrupt’:
arch/i386/kernel/apic.c:589: error: invalid lvalue in assignment
arch/i386/kernel/apic.c:608: error: invalid lvalue in assignment
...

Just to let you know that -rt5 was doing fine with very same .config .

Cheers.
-- 
rncbc aka Rui Nuno Capela
rncbc@rncbc.org


