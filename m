Return-Path: <linux-kernel-owner+w=401wt.eu-S1758883AbYGCNFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883AbYGCNFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 09:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbYGCNFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 09:05:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47575 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbYGCNFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:05:45 -0400
Date: Thu, 3 Jul 2008 15:05:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Max Asbock <masbock@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: mce_64.c: mce_cpu_quirks being ignored
Message-ID: <20080703130529.GA31372@elte.hu>
References: <1213908276.5942.16.camel@w-amax.beaverton.ibm.com> <485ACCA1.6070507@firstfloor.org> <20080625001256.GA31734@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080625001256.GA31734@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> > Venki, I did a patch for dynamic banks anyways, but haven't 
> > submitted it yet.
> 
> Yes. That particular quirk getting ignored was a bug. Below patch 
> fixes the bug, until we have the dynamic banks support.
> 
> sysfs choice configuration should not have any issues with the earlier 
> patch as we look for NR_SYSFS_BANKS in do_machine_check().
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

applied to tip/x86/mce - thanks Venki.

	Ingo
