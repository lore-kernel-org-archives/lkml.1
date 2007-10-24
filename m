Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbXJXQyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbXJXQyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761600AbXJXQiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:38:19 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58303 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761667AbXJXQiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:38:17 -0400
Date: Wed, 24 Oct 2007 17:32:45 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, davej@codemonkey.org.uk,
       cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] #if 0 cpufreq.c:cpufreq_get()
Message-ID: <20071024163245.GF32333@flint.arm.linux.org.uk>
References: <20071024162312.GH30533@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024162312.GH30533@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 06:23:12PM +0200, Adrian Bunk wrote:
> cpufreq.c:cpufreq_get() no longer has any user.

Your checking seems to be flawed.

drivers/video/sa1100fb.c:               cpufreq_get(smp_processor_id()));
drivers/video/sa1100fb.c:       pcd = get_pcd(var->pixclock, cpufreq_get(0));

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
