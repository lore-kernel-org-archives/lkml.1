Return-Path: <linux-kernel-owner+w=401wt.eu-S1755610AbYEEBxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbYEEBxb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 21:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbYEEBxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 21:53:21 -0400
Received: from uki.us.mooball.net ([66.98.178.13]:48785 "EHLO
	uki.us.mooball.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbYEEBxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 21:53:20 -0400
X-ClientAddr: 220.233.82.121
Subject: Re: [PATCH 03/56] microblaze_v2: Cpuinfo handling
From: John Williams <john.williams@petalogix.com>
To: monstr@seznam.cz
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
In-Reply-To: <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
	 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
	 <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu>
	 <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu>
Content-Type: text/plain
Organization: PetaLogix
Date: Mon, 05 May 2008 11:52:22 +1000
Message-Id: <1209952342.5798.37.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
X-Mooball.com-MailScanner-Information: Please contact the ISP for more information
X-Mooball.com-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailScanner-From: john.williams@petalogix.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> --- /dev/null
> +++ b/arch/microblaze/kernel/cpu/cpuinfo-static.c
> @@ -0,0 +1,117 @@

> +
> +	ci->cpu_clock_freq = fcpu(cpu, "timebase-frequency");

Should this be added to cpuinfo-pvr.c?


> --- /dev/null
> +++ b/include/asm-microblaze/cpuinfo.h
...

> +	/* HW debug support */
> +	int hw_debug;
> +	int num_pc_brk;
> +	int num_rd_brk;
> +	int num_wr_brk;

  +       /* CPU and system timebase info */
> +	int cpu_clock_freq;
> +

> +void set_cpuinfo_pvr_partial(struct cpuinfo *ci);

pvr_partial never got written - it can be deleted.

John


