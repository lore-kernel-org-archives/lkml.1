Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577AbZBGBUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbZBGBUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 20:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbZBGBUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 20:20:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:5138 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbZBGBUb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 20:20:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,394,1231142400"; 
   d="scan'208";a="663595436"
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: Roland Dreier <rdreier@cisco.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Eric Anholt <eric@anholt.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "drivers_video-dri@kernel-bugs.osdl.org" 
	<drivers_video-dri@kernel-bugs.osdl.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Fri, 6 Feb 2009 17:20:27 -0800
Subject: RE: [Bug #12491] i915 lockdep warning
Thread-Topic: [Bug #12491] i915 lockdep warning
Thread-Index: AcmIrLc4C24MfkrWSK+9D98h63SX2wAFRoJA
Message-ID: <F169D4F5E1F1974DBFAFABF47F60C10A1DFD867C@orsmsx507.amr.corp.intel.com>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
	<pWZw1SZjMCH.A.ciH.4vYiJB@chimera> <adar62dltg1.fsf@cisco.com>
	<200902050203.40535.rjw@sisk.pl> <adar62bchfw.fsf@cisco.com>
In-Reply-To: <adar62bchfw.fsf@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > i915: Fix potential AB-BA deadlock in i915_gem_execbuffer()
> 
> Jesse, Eric, or anybody -- does this look correct to you?  This seems
> to be triggering for several people, eg
> https://bugzilla.redhat.com/show_bug.cgi?id=481687
> 
>  - R.

I tested this on my 965 based system that showed the issue and it seemed resolved, at least no warnings in dmesg.  Lockdep was confirmed to still be enabled.

I can mark the bug fixed in korg bugzilla too.

Thank you Roland for looking into this, good work!
