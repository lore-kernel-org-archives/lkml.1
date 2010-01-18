Return-Path: <linux-kernel-owner+w=401wt.eu-S1751878Ab0ARN4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878Ab0ARN4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 08:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395Ab0ARN4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 08:56:14 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53055 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab0ARN4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 08:56:13 -0500
Subject: Re: [PATCH 1/3] perf_event: fix race in
 perf_swevent_get_recursion_context()
From: Peter Zijlstra <peterz@infradead.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B54654A.4090601@cn.fujitsu.com>
References: <4B54654A.4090601@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 14:55:58 +0100
Message-ID: <1263822958.4283.560.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 21:42 +0800, Xiao Guangrong wrote:
> It only disable preemption in perf_swevent_get_recursion_context()
> it can't avoid race of hard-irq and NMI
> 
> In this patch, we use atomic operation to avoid it and reduce
> cpu_ctx->recursion size, it also make this patch no need diable
> preemption

Uhm why?

This patch looks terminally broken

