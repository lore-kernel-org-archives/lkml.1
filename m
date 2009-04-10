Return-Path: <linux-kernel-owner+w=401wt.eu-S937226AbZDJLyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937226AbZDJLyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 07:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757143AbZDJLyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 07:54:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51092 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756862AbZDJLyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 07:54:04 -0400
Date: Fri, 10 Apr 2009 13:53:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: venkatesh.pallipadi@intel.com
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 0/6] x86, PAT, CPA: Cleanups and minor bug fixes
Message-ID: <20090410115348.GK21506@elte.hu>
References: <20090409212646.511925000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090409212646.511925000@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com> wrote:

> This patchset contains cleanups and minor bug fixes in x86 PAT and 
> CPA related code. The bugs were mostly found by code inspection. 
> There should not be any functionality changes with this patchset.
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Great, this series looks really nice!

Does this solve the problems reported in the "2.6.29 git master and 
PAT problems" thread and addressed via an earlier patch of yours:

 Subject: [PATCH] x86, PAT: Remove page granularity tracking for vm_insert_pfn maps

i am worried about this particular patch - it looks more like a 
workaround than a true realization of a bug.

	Ingo
