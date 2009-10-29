Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbZJ2AuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbZJ2AuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 20:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbZJ2AuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 20:50:24 -0400
Received: from mga12.intel.com ([143.182.124.36]:24656 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755230AbZJ2AuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 20:50:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,642,1249282800"; 
   d="scan'208";a="204980249"
Subject: Re: hackbench regression with kernel 2.6.32-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1256739779.7503.59.camel@marge.simson.net>
References: <1255079943.25078.23.camel@ymzhang>
	 <1255084986.8802.46.camel@laptop>  <1255331120.3684.43.camel@ymzhang>
	 <1255357264.10420.15.camel@twins>  <1255403522.3684.57.camel@ymzhang>
	 <1255691192.7029.13.camel@marge.simson.net>
	 <1256630584.16282.13.camel@ymzhang>
	 <1256654547.17752.13.camel@marge.simson.net>
	 <1256722141.16282.20.camel@ymzhang>
	 <1256739779.7503.59.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 29 Oct 2009 08:50:47 +0800
Message-Id: <1256777448.16282.21.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-28 at 15:22 +0100, Mike Galbraith wrote:
> On Wed, 2009-10-28 at 17:29 +0800, Zhang, Yanmin wrote:
> > 	-Mike
> > I'm investigating 5% tbench regression on Nehalem machine. perf_counter shows
> > select_task_rq_fair consumes about 5% cpu time with 2.6.32-rc1 while it consumes
> > less than 0.5% with 2.6.31.
> > 
> > Patch c88d5910890 has comments to explain it, but I still can't understand why
> > to add complicated balance logic when selecting task rq.
> > 
> > I will check which section in function ﻿select_task_rq_fair consumes so much time.
> 
> Turn off SD_WAKE_BALANCE as it was called in rc1.  See commit 182a85f.
I run testing against 2.6.32-rc1 which already includes the patch.


