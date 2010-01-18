Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320Ab0ARH1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab0ARH1H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 02:27:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633Ab0ARH1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 02:27:06 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:37441 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab0ARH1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 02:27:02 -0500
Date: Mon, 18 Jan 2010 08:27:01 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Anton Blanchard <anton@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, miltonm@bga.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] generic-ipi: Use DEFINE_PER_CPU_SHARED_ALIGNED for IPI
	data
Message-ID: <20100118072700.GC13771@kernel.dk>
References: <20100118020051.GR12666@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100118020051.GR12666@kryten>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18 2010, Anton Blanchard wrote:
> From: Milton Miller <miltonm@bga.com>
> 
> The smp ipi data is passed around and given write access by other cpus
> and should be seperated from per-cpu data consumed by this cpu.
> 
> Looking for hot lines, I saw call_function_data shared with tick_cpu_sched.

Looks good to me.

Acked-by: Jens Axboe <jens.axboe@oracle.com>

-- 
Jens Axboe

