Return-Path: <linux-kernel-owner+w=401wt.eu-S1754526AbZGFSyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbZGFSyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 14:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbZGFSy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 14:54:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:5358 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535AbZGFSy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 14:54:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,358,1243839600"; 
   d="scan'208";a="705423575"
Subject: Re: [patch 0/4] Take care of cpufreq lockdep issues (take 2)
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Dave Jones <davej@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       "kernel-testers@vger.kernel.org" <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dave Young <hidave.darkstar@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Thomas Renninger <trenn@suse.de>
In-Reply-To: <20090703000829.735976000@intel.com>
References: <20090703000829.735976000@intel.com>
Content-Type: text/plain
Date: Mon, 06 Jul 2009 11:52:37 -0700
Message-Id: <1246906357.11545.49.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-02 at 17:08 -0700, Pallipadi, Venkatesh wrote:
> Since recent chanegs to ondemand and conservative governor, there have been
> multiple reports of lockdep issues in cpufreq. Patch series takes care of
> these problems.
> 
> This is the next attempt following the one here, which was not a complete fix.
> http://lkml.indiana.edu/hypermail/linux/kernel/0906.3/01073.html
> 
> I am currently running some stress tests to make sure there are no issues with
> these patches. But, wanted to send them out for review/comments/testing
> before I head out for the long weekend.
> 
> If this patchset seems sane, the first patch in the patchset should also get
> into 30.stable.
> 

Just an update. I ran some stress test on few of my test machines over
the long weekend and havent seen any issues with this patchset.

Thanks,
Venki

