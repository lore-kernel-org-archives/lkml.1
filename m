Return-Path: <linux-kernel-owner+w=401wt.eu-S932354AbXGZKVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354AbXGZKVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 06:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763884AbXGZKVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 06:21:05 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:54070 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762832AbXGZKVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 06:21:03 -0400
Date: Thu, 26 Jul 2007 13:21:01 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
       sparclinux@vger.kernel.org
Subject: ALSA & missing dma_*_coherent on sparc32
Message-ID: <Pine.SOC.4.64.0707261317001.20971@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tried to compile current 2.6.23-rc1+git on sparc32, along with sparc 
ALSA drivers as usual. But now the compilation is broken because of 
missing dma_*_coherent on sparc32. ISTR this got chenged recently on 
sparc32...

ERROR: "dma_free_coherent" [sound/core/snd-page-alloc.ko] undefined!
ERROR: "dma_alloc_coherent" [sound/core/snd-page-alloc.ko] undefined!

-- 
Meelis Roos (mroos@linux.ee)
