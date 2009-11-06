Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbZKFGJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbZKFGJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 01:09:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756494AbZKFGJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 01:09:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:38334 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756338AbZKFGJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 01:09:11 -0500
Message-ID: <4AF3BD43.1000201@kernel.org>
Date: Thu, 05 Nov 2009 22:08:03 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] irq: remove __weak early_irq_init()
References: <2674af740911052200m141e71d5v37d621d23771aa91@mail.gmail.com>
In-Reply-To: <2674af740911052200m141e71d5v37d621d23771aa91@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yong Zhang wrote:
>>From 86a53664e3f503fe06b166fb248ed64a77212b3d Mon Sep 17 00:00:00 2001
> From: Yong Zhang <yong.zhang0@gmail.com>
> Date: Fri, 6 Nov 2009 13:53:30 +0800
> Subject: [PATCH] irq: remove __weak early_irq_init()
> 
> impact: cleanup
> 
> Since commit 12026ea16a618b289fcf457661aed24f57323a20
> early_irq_init() is always defined in kernel/irq/handle.c
> So remove the weak definition.

some arches that do not have GENERIC_HARDIRQS defined need that.

YH
