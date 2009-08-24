Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbZHXO5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbZHXO5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 10:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZHXO5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 10:57:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53053 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbZHXO5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 10:57:07 -0400
Subject: Re: [PATCH 8/15] sched: Add parameter sched_mn_power_savings to
 control MN domain sched policy
From: Peter Zijlstra <peterz@infradead.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Gautham Shenoy <ego@in.ibm.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>
In-Reply-To: <20090820133914.GW29327@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com>
	 <20090820133914.GW29327@alberich.amd.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Aug 2009 16:56:18 +0200
Message-Id: <1251125778.7538.268.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-20 at 15:39 +0200, Andreas Herrmann wrote:
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---

> +#ifdef CONFIG_SCHED_MN
> +	if (!err && mc_capable())
> +		err = sysfs_create_file(&cls->kset.kobj,
> +					&attr_sched_mn_power_savings.attr);
> +#endif

*sigh* another crappy sysfs file

Guys, can't we come up with anything better than sched_*_power_saving=n?

This configuration space is _way_ too large, and now it gets even
crazier.
