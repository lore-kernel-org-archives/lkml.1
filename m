Return-Path: <linux-kernel-owner+w=401wt.eu-S935079AbXG0J7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935079AbXG0J7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 05:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762740AbXG0J7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 05:59:00 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:55826 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761540AbXG0J67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 05:58:59 -0400
Date: Fri, 27 Jul 2007 12:58:57 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Takashi Iwai <tiwai@suse.de>
cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       sparclinux@vger.kernel.org
Subject: Re: ALSA & missing dma_*_coherent on sparc32
In-Reply-To: <s5hzm1jtiy1.wl%tiwai@suse.de>
Message-ID: <Pine.SOC.4.64.0707271257570.20751@math.ut.ee>
References: <Pine.SOC.4.64.0707261317001.20971@math.ut.ee> <s5h7ionv0xc.wl%tiwai@suse.de>
 <Pine.SOC.4.64.0707261501130.24473@math.ut.ee> <s5h6447uzrk.wl%tiwai@suse.de>
 <20070726125834.GA4041@uranus.ravnborg.org> <s5hzm1jtiy1.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> [ALSA] Fix build error without CONFIG_HAS_DMA
> 
> The recent change of include/asm-generic/dma-mapping-broken.h breaks
> the build without CONFIG_HAS_DMA.  This patch is an ad hoc fix.

This seems to fix the issue, thnaks!

-- 
Meelis Roos (mroos@linux.ee)
