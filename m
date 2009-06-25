Return-Path: <linux-kernel-owner+w=401wt.eu-S1757848AbZFYSol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848AbZFYSol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 14:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755690AbZFYSnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 14:43:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:32173 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbZFYSnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 14:43:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,292,1243839600"; 
   d="scan'208";a="158542229"
Message-Id: <20090625183354.491259000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 25 Jun 2009 11:33:54 -0700
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
Subject: [patch 0/3] Take care of cpufreq lockdep issues
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since recent chanegs to ondemand and conservative governor, there have been
multiple reports of lockdep issues in cpufreq. Patch series takes care of
these problems.

-- 

