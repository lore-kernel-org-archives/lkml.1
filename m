Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968Ab0A0SIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab0A0SIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 13:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827Ab0A0SIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 13:08:20 -0500
Received: from mga05.intel.com ([192.55.52.89]:54039 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755956Ab0A0SIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 13:08:19 -0500
Message-Id: <89kc63$fua5o0@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,355,1262592000"; 
   d="scan'208";a="535107328"
Date: Wed, 27 Jan 2010 18:08:06 +0000
To: Jesse Barnes <jbarnes@virtuousgeek.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #15004] i915: *ERROR* Execbuf while wedged
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       tomas m <tmezzadra@gmail.com>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera> <q60Z28d_9yH.A.r3H.XZMXLB@chimera> <20100127100144.4c7d8996@jbarnes-piketon>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20100127100144.4c7d8996@jbarnes-piketon>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010 10:01:44 -0800, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Sun, 24 Jan 2010 23:23:11 +0100 (CET)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15004
> > Subject		: i915: *ERROR* Execbuf while wedged
> > Submitter	: tomas m <tmezzadra@gmail.com>
> > Date		: 2010-01-07 18:53 (18 days old)
> 
> Chris, any ideas about this one?  I remember seeing a few like this
> that have been bisected to 2D driver changes recently...

Yes, this is almost certainly our userspace driver sending the GPU into a
spin. And no, we haven't identified the cause yet, there have a been a lot
of conflicting reports and guesswork, with very little information.

-- 
Chris Wilson, Intel Open Source Technology Centre
