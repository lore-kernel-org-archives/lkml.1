Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbZJSHck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbZJSHck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 03:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755428AbZJSHcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 03:32:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38574 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755405AbZJSHcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 03:32:39 -0400
Date: Mon, 19 Oct 2009 09:32:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <gregkh@suse.de>, david@lang.hm,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: removing existing working drivers via staging
Message-ID: <20091019073230.GD17960@elte.hu>
References: <alpine.DEB.2.00.0910142213590.22169@asgard.lang.hm> <4AD74ED7.9070501@s5r6.in-berlin.de> <alpine.DEB.2.00.0910150936310.22169@asgard.lang.hm> <20091015164726.GA10125@suse.de> <20091017172743.GE1526@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091017172743.GE1526@ucw.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> On Thu 2009-10-15 09:47:26, Greg KH wrote:
> > On Thu, Oct 15, 2009 at 09:39:51AM -0700, david@lang.hm wrote:
> > > however, what I think I saw proposed was to move drivers that need to be 
> > > 'cleaned up', to staging and then dropping them if they don't get cleaned.
> > 
> > What is "proposed" is the following:
> > 
> > 	- For drivers currently in the kernel tree, that the subsystem
> > 	  maintainer, for whatever reason, feels is obsolete / broken /
> > 	  needs major cleaning / wants to get rid of, can be submitted
> > 	  to the staging maintainer to be moved to the drivers/staging/
> > 	  directory.
> > 	- For a file to be moved into this directory, all of the normal
> > 	  staging rules apply, including most importantly, a TODO file
> > 	  listing what needs to be done to the driver in order for it to
> > 	  be moved back into the main portion of the kernel tree.
> > 	- If, after a period of 3 releases, no work has been done on the
> > 	  driver by anyone, the driver will be removed from the staging
> > 	  tree, just like all drivers in the staging tree.
> > 
> > Note, as always, if a driver wants to come back from removal of the
> > staging tree, a simple email to the staging maintainer, along with the
> > promise that work will be done, is all it takes to resurrect it.
> > 
> > Sound good?
> > 
> > Now, where to put these "rules"?  Any suggestions?
> 
> I'm not sure it sounds good. It should not be named 'staging' at 
> least.

Why not? It's a good match - a driver gets staged because it's not fit 
for upstream.

The usual staging rules apply regardless of where the driver came from 
(outside or inside the kernel): someone has to care about it and it has 
to be fixed.

	Ingo
