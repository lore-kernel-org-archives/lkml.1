Return-Path: <linux-kernel-owner+w=401wt.eu-S1755605AbXJXJxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbXJXJxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 05:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbXJXJxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 05:53:16 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:55584 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbXJXJxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 05:53:15 -0400
Message-ID: <471F15D5.3050100@linux.vnet.ibm.com>
Date: Wed, 24 Oct 2007 15:22:21 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Michael Neuling <mikey@neuling.org>
CC: paulus@samba.org, akpm@linux-foundation.org, linux390@de.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-s390@vger.kernel.org
Subject: Re: [PATCH] taskstats scaled time cleanup
References: <8789.1193208897@neuling.org>
In-Reply-To: <8789.1193208897@neuling.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Neuling wrote:
> This moves the ability to scale cputime into generic code.  This
> allows us to fix the issue in kernel/timer.c (noticed by Balbir) where
> we could only add an unscaled value to the scaled utime/stime.
> 
> This adds a cputime_to_scaled function.  As before, the POWERPC
> version does the scaling based on the last SPURR/PURR ratio
> calculated.  The generic and s390 (only other arch to implement
> asm/cputime.h) versions are both NOPs.
> 
> Also moves the SPURR and PURR snapshots closer.
> 
> Signed-off-by: Michael Neuling <mikey@neuling.org>

Looks good to me

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
