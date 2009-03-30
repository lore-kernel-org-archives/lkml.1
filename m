Return-Path: <linux-kernel-owner+w=401wt.eu-S1761141AbZC3Vr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761141AbZC3Vr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 17:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbZC3Vrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 17:47:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:7750 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755580AbZC3Vrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 17:47:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,448,1233561600"; 
   d="scan'208";a="677287328"
Subject: Re: 2.6.29 git master and PAT problems
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <200903302331.10995.a.miskiewicz@gmail.com>
References: <200903302317.04515.a.miskiewicz@gmail.com>
	 <7E82351C108FA840AB1866AC776AEC4657E57368@orsmsx505.amr.corp.intel.com>
	 <200903302331.10995.a.miskiewicz@gmail.com>
Content-Type: text/plain
Date: Mon, 30 Mar 2009 14:45:55 -0700
Message-Id: <1238449555.4529.1095.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-30 at 14:31 -0700, Arkadiusz Miskiewicz wrote:
> On Monday 30 of March 2009, Pallipadi, Venkatesh wrote:
> > Patch here should get rid of these errors.
> >
> > http://marc.info/?l=linux-kernel&m=123788806506230&w=2
> >
> > The patch is in tip and on its way to upstream.
> 
> The problem is that kernel I'm running already contains this patch (it's
> merged already). Other ideas?
> 
> ratelimiting that error is good IMO anyway.

Rate limiting will just work around the problem here. Ideally we should
never see these errors. So, it will be better if we can narrow down on
the bug resulting in these error messages.

Can you please send me the output of
# cat /debug/x86/pat_memtype_list
with debugfs mounted.
and
# cat /proc/mtrr

Also, do you see the errors soon after you boot or only when you run
something on X or exit X or somethign else?

Thanks,
Venki


