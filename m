Return-Path: <linux-kernel-owner+w=401wt.eu-S1752929AbZBPRog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbZBPRog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 12:44:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbZBPRo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 12:44:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41581 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbZBPRo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 12:44:27 -0500
Subject: Re: [PATCH 2/3] sched: Fix the wakeup nomination for
 sched_mc/smt_power_savings.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, svaidy@linux.vnet.ibm.com, mingo@elte.hu,
       suresh.b.siddha@intel.com, balbir@in.ibm.com, dipankar@in.ibm.com,
       efault@gmx.de, andi@firstfloor.org
In-Reply-To: <20090216165111.12804.41620.stgit@sofia.in.ibm.com>
References: <20090216164719.12804.37013.stgit@sofia.in.ibm.com>
	 <20090216165111.12804.41620.stgit@sofia.in.ibm.com>
Content-Type: text/plain
Date: Mon, 16 Feb 2009 18:44:10 +0100
Message-Id: <1234806250.30178.186.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-16 at 22:21 +0530, Gautham R Shenoy wrote:
> +/* Assign the sched-domain level which can nominate preferred wake-up cpu */
> +       rd->sched_mc_preferred_wakeup_cpu = UINT_MAX;
> +       rd->authorized_nomination_level = SD_LV_NONE;


/me wonders what's wrong with:

	/*
	 * Assing ....
         * ... cpu
	 */

