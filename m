Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbYBYKQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbYBYKQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 05:16:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbYBYKQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 05:16:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57473 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583AbYBYKQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 05:16:20 -0500
Date: Mon, 25 Feb 2008 11:15:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yi Yang <yi.y.yang@intel.com>
Cc: akpm@linux-foundation.org, venkatesh.pallipadi@intel.com,
       cpufreq@lists.linux.org.uk, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2.6.25-rc3] cpuidle: fix cpuidle time and usage overflow
Message-ID: <20080225101533.GB30685@elte.hu>
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com> <1201043126.3861.5.camel@yangyi-dev.bj.intel.com> <1203032921.3897.10.camel@yangyi-dev.bj.intel.com> <1203900372.4954.8.camel@yangyi-dev.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203900372.4954.8.camel@yangyi-dev.bj.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Yi Yang <yi.y.yang@intel.com> wrote:

> cpuidle C-state sysfs node time and usage are very easy to overflow 
> because they are all of unsigned int type, time will overflow within 
> about two hours, usage will take longer time to overflow, but they are 
> increasing for ever.
> 
> This patch will convert them to unsigned long long.

what happens if such an overflow happens - any particular regression or 
other misbehavior, or just funny looking stats in sysfs?

	Ingo
