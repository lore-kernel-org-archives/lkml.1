Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbYIQIYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbYIQIYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 04:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbYIQIY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 04:24:27 -0400
Received: from mga06.intel.com ([134.134.136.21]:34406 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751503AbYIQIY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 04:24:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,414,1217833200"; 
   d="scan'208";a="440348127"
Subject: Re: [2.6.27-rc6 regression] Intermittent boot problem with
	2.6.27-rc6
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       torvalds@linux-foundation.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080916200414.GB16993@localdomain>
References: <20080916200414.GB16993@localdomain>
Content-Type: text/plain
Date: Wed, 17 Sep 2008 16:23:06 +0800
Message-Id: <1221639786.25574.27.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-09-16 at 13:04 -0700, Ravikiran G Thirumalai wrote:
> Hi,
> Booting 2.6.27-rc6, or the current Linus' git on large x86_64 NUMA wedges
> intermittently.  This happens on machines with more than 4 NUMA nodes.  The
> same kernel boots on similar hardware with fewer NUMA nodes (or boards).
> 2.6.27-rc3 seemed to boot well on similar configurations, so looks like a
> regression crept in between 2.6.27-rc3 and rc6.
> 
> I am trying a few things -- commandline options to eliminate popular
> suspects (such as unsynced tsc clocksources)  as well as git bisect, but
> wanted to report the regression in the meanwhile.
> Here's the dmesg of a 24 core 6 node wedged system.
Because the git doesn't include my patch. Pls. try it.

http://marc.info/?l=linux-kernel&m=122093094701219&w=2

yanmin


