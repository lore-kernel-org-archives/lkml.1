Return-Path: <linux-kernel-owner+w=401wt.eu-S1757585AbZBKSO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585AbZBKSO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 13:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755666AbZBKSOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 13:14:49 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:54493 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbZBKSOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 13:14:48 -0500
X-IronPort-AV: E=Sophos;i="4.38,193,1233532800"; 
   d="scan'208";a="247537873"
From: Roland Dreier <rdreier@cisco.com>
To: Eric Anholt <eric@anholt.net>
Cc: "Brandeburg\, Jesse" <jesse.brandeburg@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "drivers_video-dri\@kernel-bugs.osdl.org" 
	<drivers_video-dri@kernel-bugs.osdl.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       intel-gfx@lists.freedesktop.org
Subject: Re: [Bug #12491] i915 lockdep warning
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
	<pWZw1SZjMCH.A.ciH.4vYiJB@chimera> <adar62dltg1.fsf@cisco.com>
	<200902050203.40535.rjw@sisk.pl> <adar62bchfw.fsf@cisco.com>
	<F169D4F5E1F1974DBFAFABF47F60C10A1DFD867C@orsmsx507.amr.corp.intel.com>
	<adabptfc90m.fsf@cisco.com> <1234312992.32506.30.camel@gaiman>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 11 Feb 2009 10:14:13 -0800
In-Reply-To: <1234312992.32506.30.camel@gaiman> (Eric Anholt's message of
	"Tue, 10 Feb 2009 16:43:12 -0800")
Message-ID: <adaprho96yy.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Feb 2009 18:14:13.0592 (UTC) FILETIME=[8B2E1D80:01C98C74]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > This only fixes 1 of the about 4 of this type of deadlock, but it looks
 > like a fine fix for that and I've put it in my tree.  Thanks!

Heh, just fixing what I saw reported.  probably once this gets in the
harder reports will pop up because lockdep won't disable itself quite so
soon...

 - R.
