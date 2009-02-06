Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbZBFWqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbZBFWqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 17:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbZBFWqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 17:46:14 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:56526 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbZBFWqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 17:46:13 -0500
X-IronPort-AV: E=Sophos;i="4.37,393,1231113600"; 
   d="scan'208";a="29443700"
From: Roland Dreier <rdreier@cisco.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Eric Anholt <eric@anholt.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Brandeburg\, Jesse" <jesse.brandeburg@intel.com>,
       drivers_video-dri@kernel-bugs.osdl.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Bug #12491] i915 lockdep warning
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
	<pWZw1SZjMCH.A.ciH.4vYiJB@chimera> <adar62dltg1.fsf@cisco.com>
	<200902050203.40535.rjw@sisk.pl>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 06 Feb 2009 14:46:11 -0800
In-Reply-To: <200902050203.40535.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Thu, 5 Feb 2009 02:03:39 +0100")
Message-ID: <adar62bchfw.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Feb 2009 22:46:11.0982 (UTC) FILETIME=[B5A212E0:01C988AC]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > i915: Fix potential AB-BA deadlock in i915_gem_execbuffer()

Jesse, Eric, or anybody -- does this look correct to you?  This seems to
be triggering for several people, eg
https://bugzilla.redhat.com/show_bug.cgi?id=481687

 - R.
