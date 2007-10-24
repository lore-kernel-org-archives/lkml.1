Return-Path: <linux-kernel-owner+w=401wt.eu-S1758696AbXJXSkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696AbXJXSkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 14:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbXJXSjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 14:39:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269AbXJXSjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 14:39:52 -0400
Date: Wed, 24 Oct 2007 14:39:20 -0400
From: Dave Jones <davej@redhat.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, davej@codemonkey.org.uk,
       cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] #if 0 cpufreq.c:cpufreq_get()
Message-ID: <20071024183920.GF14357@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Adrian Bunk <bunk@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	davej@codemonkey.org.uk, cpufreq@lists.linux.org.uk,
	linux-kernel@vger.kernel.org
References: <20071024162312.GH30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024162312.GH30533@stusta.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 06:23:12PM +0200, Adrian Bunk wrote:
 > cpufreq.c:cpufreq_get() no longer has any user.
 > 
 > Signed-off-by: Adrian Bunk <bunk@kernel.org>

ARM uses it.

drivers/pcmcia/sa11xx_base.c:   return sa1100_pcmcia_set_mecr(skt, cpufreq_get(0));
drivers/pcmcia/sa11xx_base.c:   unsigned int clock = cpufreq_get(0);
drivers/video/sa1100fb.c:               cpufreq_get(smp_processor_id()));
drivers/video/sa1100fb.c:       pcd = get_pcd(var->pixclock, cpufreq_get(0));

	Dave

-- 
http://www.codemonkey.org.uk
