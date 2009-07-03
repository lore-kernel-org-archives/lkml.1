Return-Path: <linux-kernel-owner+w=401wt.eu-S1757193AbZGCA1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbZGCA1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 20:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbZGCA1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 20:27:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:3112 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbZGCA1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 20:27:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,337,1243839600"; 
   d="scan'208";a="471654459"
Message-Id: <20090703000829.735976000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 02 Jul 2009 17:08:29 -0700
From: venkatesh.pallipadi@intel.com
To: "Dave Jones" <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
       kernel-testers@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Dave Young" <hidave.darkstar@gmail.com>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Thomas Renninger" <trenn@suse.de>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>
Subject: [patch 0/4] Take care of cpufreq lockdep issues (take 2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since recent chanegs to ondemand and conservative governor, there have been
multiple reports of lockdep issues in cpufreq. Patch series takes care of
these problems.

This is the next attempt following the one here, which was not a complete fix.
http://lkml.indiana.edu/hypermail/linux/kernel/0906.3/01073.html

I am currently running some stress tests to make sure there are no issues with
these patches. But, wanted to send them out for review/comments/testing
before I head out for the long weekend.

If this patchset seems sane, the first patch in the patchset should also get
into 30.stable.

-- 

