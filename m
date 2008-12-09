Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbYLIQ2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbYLIQ2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 11:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbYLIQ2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 11:28:46 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56258 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbYLIQ2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 11:28:45 -0500
Date: Tue, 9 Dec 2008 11:27:45 -0500
From: Jason Baron <jbaron@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       fweisbec@gmail.com
Subject: Re: [rfc] [patch] hook tracer to dynamic debug
Message-ID: <20081209162745.GA3107@redhat.com>
References: <20081205193928.GA3134@redhat.com> <20081207054840.GA20541@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081207054840.GA20541@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2008 at 09:48:40PM -0800, Greg KH wrote:
> On Fri, Dec 05, 2008 at 02:39:28PM -0500, Jason Baron wrote:
> > hi,
> > 
> > Currently, the dynamic debug framework uses 'printk' for output. Here,
> > i've hooked the backend of the dynamic debug framework to the tracing 
> > framework. This allows the dynamic debug output to be seaprated from the
> > system log, and allows for higher performance.
> 
> Is this really an issue most of the time?
> 
> I know logs can get full, but this seems like a bit of an overkill :)
> 
> > I've implemented it as a compile time option, but a user might want to
> > be able to toggle b/w 'printk' and the tracer at run-time...other
> > ideas? Patch is against the -tip tree...
> 
> It would have to be a run-time option if you want any distro to ever be
> able to enable this in their kernels.
> 

There haven't been any specfic complaints about this, although the all
'on' case does really spew quite a lot into the logs. Using Frederic's
suggestion I'm able to implement this with only a few lines of code...so
I'll keep it around if we ever need it...

thanks,

-Jason
