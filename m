Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbYBYK0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbYBYK0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 05:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbYBYK0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 05:26:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:43159 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbYBYK0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 05:26:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,400,1199692800"; 
   d="scan'208";a="301506610"
Subject: Re: [PATCH 2.6.25-rc3] cpuidle: fix cpuidle time and usage overflow
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, venkatesh.pallipadi@intel.com,
       cpufreq@lists.linux.org.uk, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <20080225101533.GB30685@elte.hu>
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com>
	 <1201043126.3861.5.camel@yangyi-dev.bj.intel.com>
	 <1203032921.3897.10.camel@yangyi-dev.bj.intel.com>
	 <1203900372.4954.8.camel@yangyi-dev.bj.intel.com>
	 <20080225101533.GB30685@elte.hu>
Content-Type: text/plain
Organization: Intel
Date: Mon, 25 Feb 2008 09:10:26 +0800
Message-Id: <1203901826.4954.11.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-02-25 at 11:15 +0100, Ingo Molnar wrote:
> * Yi Yang <yi.y.yang@intel.com> wrote:
> 
> > cpuidle C-state sysfs node time and usage are very easy to overflow 
> > because they are all of unsigned int type, time will overflow within 
> > about two hours, usage will take longer time to overflow, but they are 
> > increasing for ever.
> > 
> > This patch will convert them to unsigned long long.
> 
> what happens if such an overflow happens - any particular regression or 
> other misbehavior, or just funny looking stats in sysfs?
They are just stats info in sysfs, cpuidle's behaviors don't depend on
them. I didn't notice any regression or misbehaviors.

> 
> 	Ingo
> -
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

