Return-Path: <linux-kernel-owner+w=401wt.eu-S932961AbYBUVBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961AbYBUVBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 16:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757272AbYBUVA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 16:00:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756610AbYBUVA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 16:00:58 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Markus Metzger <markus.t.metzger@intel.com>
X-Fcc: ~/Mail/linus
Cc: ak@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de, markus.t.metzger@gmail.com,
       suresh.b.siddha@intel.com, akpm@linux-foundation.org,
       mtk.manpages@gmail.com, eranian@googlemail.com
Subject: Re: [patch 1/2] x86, ptrace: support pebs in ds.c
In-Reply-To: Markus Metzger's message of  Wednesday, 13 February 2008 11:23:49 +0100 <20080213112349.A3283@sedona.ch.intel.com>
References: <20080213112349.A3283@sedona.ch.intel.com>
Emacs: no job too big... no job.
Message-Id: <20080221210026.7B1C62701D5@magilla.localdomain>
Date: Thu, 21 Feb 2008 13:00:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry I haven't replied in this thread sooner.

I would like to see all the BTS and DS work wait until after 2.6.25.
We have a lot of x86 churn in 2.6.25 already, and I think we'd do
better without adding this wrinkle at the same time.

The low-level implementation pieces should gel a bit more in -mm or
whereever.  They should both get more testing and also get more
concrete use from the perfmon2 integration effort to iron out their
internal interface kinks.

For the user-level interface, we should not be hasty with cooking up
hairy ptrace extensions.  Personally, I'd prefer that we never add a
ptrace-based interface for this (ptrace must die).  I think it will
fit much better either merged into the interfaces that come from
perfmon2 integration, or into what replaces ptrace when that comes.
There is not yet any different userland interface framework in the
tree to base it on, so ptrace extensions may be better than nothing if
they are well-gelled in 2.6.26 and nothing else is close to ready.
But I also don't know of anyone desperate and about to burst from lack
of BTS functionality.


Thanks,
Roland
