Return-Path: <linux-kernel-owner+w=401wt.eu-S936642AbXGMJdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936642AbXGMJdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 05:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761714AbXGMJdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 05:33:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:27339 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759312AbXGMJdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 05:33:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,536,1175497200"; 
   d="scan'208";a="105860000"
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base
	hibernation
From: "Huang, Ying" <ying.huang@intel.com>
To: david@lang.hm
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
In-Reply-To: <Pine.LNX.4.64.0707121953440.25614@asgard.lang.hm>
References: <1184167831.12556.13.camel@caritas-dev.intel.com>
	 <200707121453.49616.rjw@sisk.pl>
	 <Pine.LNX.4.64.0707121150460.25614@asgard.lang.hm>
	 <200707122134.29991.rjw@sisk.pl>
	 <Pine.LNX.4.64.0707121953440.25614@asgard.lang.hm>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 13 Jul 2007 17:32:54 +0000
Message-Id: <1184347974.4523.30.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 13 Jul 2007 09:33:37.0022 (UTC) FILETIME=[E38E89E0:01C7C530]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 20:06 -0700, david@lang.hm wrote:
> >> I agree, a stipped down hibernate kernel can be very small, not allocating
> >> this memory until it's needed is a step for the final polishing.
> >
> > I'm not sure if I agree with that.  In any case, having to use two different
> > kernels for hibernation would be a big drawback.
> 
> I see it as a big advantage to not have to use the main kernel for the 
> suspend. please keep it as an option at least.

Yes. It has additional bonus to make it possible to write/read image
from a program other than main kernel. For example, for a specific
mobile device product (Such as Intel MID), a customized ultra-small
program (or kernel) can be composed to write/read image. That way, the
hibernate/resume time can be reduced to minimal.

Best Regards,
Huang Ying
