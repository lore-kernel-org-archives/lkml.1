Return-Path: <linux-kernel-owner+w=401wt.eu-S1752582AbZBPRnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbZBPRnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 12:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbZBPRnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 12:43:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:49805 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbZBPRnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 12:43:14 -0500
Subject: Re: [PATCH 1/3] sched: code cleanup - sd_power_saving_flags(),
 sd_balance_for_mc/package_power()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, svaidy@linux.vnet.ibm.com, mingo@elte.hu,
       suresh.b.siddha@intel.com, balbir@in.ibm.com, dipankar@in.ibm.com,
       efault@gmx.de, andi@firstfloor.org
In-Reply-To: <20090216165105.12804.32344.stgit@sofia.in.ibm.com>
References: <20090216164719.12804.37013.stgit@sofia.in.ibm.com>
	 <20090216165105.12804.32344.stgit@sofia.in.ibm.com>
Content-Type: text/plain
Date: Mon, 16 Feb 2009 18:43:01 +0100
Message-Id: <1234806181.30178.183.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-16 at 22:21 +0530, Gautham R Shenoy wrote:

> +enum sched_domain_level {
> +	SD_LV_NONE = 0,
> +	SD_LV_SIBLING,
> +	SD_LV_MC,
> +	SD_LV_CPU,
> +	SD_LV_NODE,
> +	SD_LV_ALLNODES,
> +	SD_LV_MAX
> +};


Better names would be:

 LV_THREAD
 LV_CORE
 LV_PACKAGE
 LV_NODE

But I realize that renaming these is going to be painful, however could
we at least provide proper comments with these to describe them. I
always get confused.


