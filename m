Return-Path: <linux-kernel-owner+w=401wt.eu-S935621AbXKQBJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935621AbXKQBJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 20:09:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935566AbXKQBIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 20:08:31 -0500
Received: from ns.suse.de ([195.135.220.2]:48659 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935553AbXKQBIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 20:08:30 -0500
Date: Fri, 16 Nov 2007 17:07:16 -0800
From: Greg KH <gregkh@suse.de>
To: David Miller <davem@davemloft.net>
Cc: dean@arctic.org, andi@firstfloor.org, mucci@cs.utk.edu,
       akpm@linux-foundation.org, eranian@hpl.hp.com, wcohen@redhat.com,
       robert.richter@amd.com, linux-kernel@vger.kernel.org,
       ptools-perfapi@cs.utk.edu
Subject: Re: perfmon2 merge news
Message-ID: <20071117010716.GA13708@suse.de>
References: <A42C2398-2EAB-460C-95C7-686A34A76F82@cs.utk.edu> <p737ikicjbn.fsf@bingen.suse.de> <alpine.DEB.0.9999.0711160943470.15441@twinlark.arctic.org> <20071116.162905.143357955.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116.162905.143357955.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 04:29:05PM -0800, David Miller wrote:
> From: dean gaudet <dean@arctic.org>
> Date: Fri, 16 Nov 2007 09:51:08 -0800 (PST)
> 
> > On Fri, 16 Nov 2007, Andi Kleen wrote:
> > 
> > > I didn't see a clear list. 
> > 
> > - cross platform extensible API for configuring perf counters
> > - support for multiplexed counters
> > - support for virtualized 64-bit counters
> > - support for PC and call graph sampling at specific intervals
> > - support for reading counters not necessarily with sampling
> > - taskswitch support for counters
> > - API available from userland
> > - ability to self-monitor: need select/poll/etc interface
> > - support for PEBS, IBS and whatever other new perf monitoring 
> >   infrastructure the vendors through at us in the future
> > - low overhead:  must minimize the "probe effect" of monitoring
> > - low noise in measurements:  cannot achieve this in userland
> > 
> > permon2 has all of this and more i've probably neglected...
> 
> I want to state that even though I've been a stickler on the system
> call stuff, in general I want to see perfmon2 go into tree and I agree
> with how most of the infrastructure is implemented and the features it
> provides.

Now if we only had a series of patches that we could actually review and
apply to the -mm tree so that people can try them out... :)

thanks,

greg k-h
