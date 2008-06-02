Return-Path: <linux-kernel-owner+w=401wt.eu-S1756052AbYFBQhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbYFBQhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 12:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbYFBQhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 12:37:42 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63362 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbYFBQhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 12:37:41 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5307"; a="3434819"
Message-ID: <484421E6.30709@qualcomm.com>
Date: Mon, 02 Jun 2008 09:37:58 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, rdunlap@xenotime.net
Subject: Re: [PATCH] genirq: Expose default irq affinity mask (take 3)
References: <1212084172-21459-1-git-send-email-maxk@qualcomm.com> <20080602102340.71d2399f.pj@sgi.com>
In-Reply-To: <20080602102340.71d2399f.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Max,
> 
> I realized, when reading this again, that the default masks
> are not ffffffff.  That's the default only on systems with
> no more than 32 CPUs.  Rather I suspect that the default is
> CPU_MASK_ALL.  Indeed, your patch has:
> 
>    cpumask_t irq_default_affinity = CPU_MASK_ALL;
> 
> This affects a few mentions of ffffffff in the Docs.
Good point.


> Otherwise looks good - thanks.
> 
> Acked-by: Paul Jackson <pj@sgi.com>

Thanx.

btw What's the procedure for including Acked-by ?
cut&paste into the patch description and resend ?

Max

