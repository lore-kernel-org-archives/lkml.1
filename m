Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbZAVThg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbZAVThg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 14:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756214AbZAVThV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 14:37:21 -0500
Received: from kroah.org ([198.145.64.141]:50916 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752895AbZAVThU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 14:37:20 -0500
Date: Thu, 22 Jan 2009 11:04:52 -0800
From: Greg KH <greg@kroah.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>, Nick Piggin <npiggin@suse.de>,
       Tony Luck <tony.luck@gmail.com>, Robin Holt <holt@sgi.com>
Subject: Re: [PATCH] configure HAVE_UNSTABLE_SCHED_CLOCK for SGI_SN systems
Message-ID: <20090122190452.GA20770@kroah.com>
References: <20090106162741.GA7991@sgi.com> <20090115184832.GE10674@kroah.com> <57C9024A16AD2D4C97DC78E552063EA35CD8C4C3@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA35CD8C4C3@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 11:21:05AM -0800, Luck, Tony wrote:
> > > Greg, if everyone is OK with this patch, this should also be applied
> > > to all stable trees starting with 2.6.26.
> 
> > What is the status of this going into Linus's tree?
> 
> I'm about to ask Linus to pull a modified version that does
> a "select HAVE_UNSTABLE_SCHED_CLOCK" for all IA64 systems ...
> SGI sched_clock() is a lot less "stable" than most, but all
> ia64 systems can hit this as the ar.itc cycle counter is only
> s/w synchronized between cpus.

Thanks, I see it now and will queue it up for the next -stable releases.

greg k-h
