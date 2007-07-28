Return-Path: <linux-kernel-owner+w=401wt.eu-S938561AbXG1Ar0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938561AbXG1Ar0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 20:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938253AbXG1ArR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 20:47:17 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4557 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938070AbXG1ArR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 20:47:17 -0400
Date: Fri, 27 Jul 2007 20:46:36 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       martin.pitt@ubuntu.com, wwoods@redhat.com
Subject: Re: [PATCH 2/3] core_pattern: allow passing of arguments to user mode helper when core_pattern is a pipe
Message-ID: <20070728004411.GA3021@localhost.localdomain>
References: <20070727200746.GC18946@hmsreliant.homelinux.net> <46AA5B7B.7040406@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AA5B7B.7040406@goop.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 01:54:19PM -0700, Jeremy Fitzhardinge wrote:
> Neil Horman wrote:
> > +	int helper_argc = 0;
> >   
> > +		helper_argv = argv_split(GFP_KERNEL, corename+1, &helper_argc);
> >   
> 
> Hm, I suspect most users of argv_split don't really care about argc, so
> it would useful to change argv_split to take NULL as the argc pointer,
> rather than declare a bunch of unused variables.  Interested in throwing
> a patch together?
> 
>     J


Gladly, I'll take care of it next week.

Regards
Neil

