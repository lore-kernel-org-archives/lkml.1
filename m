Return-Path: <linux-kernel-owner+w=401wt.eu-S1761321AbXLUMb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761321AbXLUMb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 07:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbXLUMbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 07:31:42 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:55556 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbXLUMbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 07:31:41 -0500
Date: Fri, 21 Dec 2007 14:31:39 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Warnings from sched_debug.c
In-Reply-To: <20071221110336.GB29047@elte.hu>
Message-ID: <Pine.SOC.4.64.0712211423400.24473@math.ut.ee>
References: <Pine.SOC.4.64.0712211217170.16480@math.ut.ee> <20071221110336.GB29047@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> it should be harmless. Does the patch below fix the warnings?

Yes, the warnings are gone, thanks!

However, I found another somewhat strange thing while testing it - 
touching kernels/sched_debug.c does not cause a recompile since 
sched_debug.c is only #included from sched.c. Found it because I was 
looking for sched_debug.o recompile.

-- 
Meelis Roos (mroos@linux.ee)
