Return-Path: <linux-kernel-owner+w=401wt.eu-S1757809AbZDOHpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809AbZDOHpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 03:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbZDOHoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 03:44:54 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:41370 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbZDOHoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 03:44:54 -0400
Date: Wed, 15 Apr 2009 09:46:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <srostedt@redhat.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: TRACE_BRANCH_PROFILING breaks gcc warnings
Message-ID: <20090415074659.GA21764@uranus.ravnborg.org>
References: <1239748090.4205.26.camel@johannes.local> <1239748293.21121.60.camel@localhost.localdomain> <20090415073720.GC18192@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415073720.GC18192@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > This has been mentioned before, and I've asked about sending a 
> > patch that would prevent TRACE_BRANCH_PROFILING from being 
> > selected with an allyesconfig.
> > 
> > It is easy to do. I could make it a selection and not a boolean 
> > and it will not select it as default, even for allyes/modconfig

We should have a symbol that is only set for allyesconfig builds.

Then we could do something like:

config TRACE_BRANCH_PROFILING
	depends on !ALLYESCONFIG

The advantage is that it is obvious why we have defiend
it like this rather than some inverse symbols.

I looked at generating such symbol in kconfig long time
ago but never finished it.

	Sam
