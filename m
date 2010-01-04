Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268Ab0ADJZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab0ADJZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 04:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471Ab0ADJZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 04:25:45 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37585 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab0ADJZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 04:25:45 -0500
Subject: Re: [RFC PATCH] sched: Pass affine target cpu into wake_affine
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Mike Galbraith <efault@gmx.de>, lkml <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <1262595827.22471.108.camel@minggr.sh.intel.com>
References: <1262595827.22471.108.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Jan 2010 10:25:05 +0100
Message-ID: <1262597105.6408.99.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-04 at 17:03 +0800, Lin Ming wrote:
> commit a03ecf08d7bbdd979d81163ea13d194fe21ad339
> Author: Lin Ming <ming.m.lin@intel.com>
> Date:   Mon Jan 4 14:14:50 2010 +0800
> 
>     sched: Pass affine target cpu into wake_affine
>     
>     Since commit a1f84a3(sched: Check for an idle shared cache in select_task_rq_fair()),
>     the affine target maybe adjusted to any idle cpu in cache sharing domains
>     instead of current cpu.
>     But wake_affine still use current cpu to calculate load which is wrong.
>     
>     This patch passes affine cpu into wake_affine.
>     

Does this at all help with that regression?

