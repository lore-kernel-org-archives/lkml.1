Return-Path: <linux-kernel-owner+w=401wt.eu-S932113AbXCHGDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbXCHGDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 01:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932240AbXCHGDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 01:03:51 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50594 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932113AbXCHGDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 01:03:50 -0500
Date: Wed, 7 Mar 2007 22:03:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux-kernel@vger.kernel.org, ck@vds.kolivas.org
Subject: Re: [PATCH] [RSDL-mm 0/6] RSDL cpu scheduler for -mm
Message-Id: <20070307220333.1d6fff96.akpm@linux-foundation.org>
In-Reply-To: <200703081625.06383.kernel@kolivas.org>
References: <200703071226.43238.kernel@kolivas.org>
	<20070307185430.31fb48b8.akpm@linux-foundation.org>
	<20070307201502.4e93c5d5.akpm@linux-foundation.org>
	<200703081625.06383.kernel@kolivas.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 8 Mar 2007 16:25:05 +1100 Con Kolivas <kernel@kolivas.org> wrote:
> > It also boots OK on a very similar but somewhat older Nocona machine. 
> > Perhaps due to config changes: 
> > http://userweb.kernel.org/~akpm/ck/config-ok.txt
> 
> Ok I just remembered that not only did I expect the cpu task to never be 
> scheduled and it _might_ be scheduled on sched_init, it is actually 
> _consciously_ scheduled on hotplug cpu which I have no way of handling at the 
> moment. On both your configs I noticed you had hotplug cpu enabled, but 
> perhaps it isn't really being used on the more conservative config. So this 
> is something I already know I need to handle. Did your ppc that had 
> the "bitmap error" have hotplug cpu enabled? It might be an unrelated 
> bug^Wphenomenon.

The powerpc config has CONFIG_HOTPLUG_CPU=n
