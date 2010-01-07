Return-Path: <linux-kernel-owner+w=401wt.eu-S932931Ab0AGJQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931Ab0AGJQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 04:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932840Ab0AGJQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 04:16:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58257 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab0AGJQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 04:16:12 -0500
Subject: Re: [RFC PATCH] sched: Pass affine target cpu into wake_affine
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Mike Galbraith <efault@gmx.de>, lkml <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <1262853903.18931.17.camel@minggr.sh.intel.com>
References: <1262595827.22471.108.camel@minggr.sh.intel.com>
	 <1262659686.22471.121.camel@minggr.sh.intel.com>
	 <1262663058.5748.32.camel@marge.simson.net>
	 <1262673817.9534.37.camel@marge.simson.net>
	 <1262853903.18931.17.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jan 2010 10:15:33 +0100
Message-ID: <1262855733.4049.92.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 16:45 +0800, Lin Ming wrote:

> I tested on below 2 machines with the 2 patches both applied and the
> oltp(sysbench+mysql) data shows good.
> Tigerton x86_64 machine: 16cpus(4P/4Cores), 40G mem
> IA64 machine: 32cpus(4P/4Cores/HT), 16G mem
> 
> Compared with upstream 2.6.33-rc2, IA64 improves ~15% and Tigerton
> improves ~3%.

I rather like your patch, so I'll queue both up.

