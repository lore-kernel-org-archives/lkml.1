Return-Path: <linux-kernel-owner+w=401wt.eu-S932860AbXBWXRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860AbXBWXRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 18:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933261AbXBWXRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 18:17:20 -0500
Received: from sccrmhc15.comcast.net ([204.127.200.85]:64222 "EHLO
	sccrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932860AbXBWXRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 18:17:19 -0500
Date: Fri, 23 Feb 2007 15:17:29 -0800
From: Deepak Saxena <dsaxena@plexity.net>
To: Matthieu CASTET <castet.matthieu@free.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow kernel to build on Cygwin
Message-ID: <20070223231729.GA3115@plexity.net>
Reply-To: dsaxena@plexity.net
References: <20070223034343.GA3320@plexity.net> <loom.20070223T213146-410@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20070223T213146-410@post.gmane.org>
Organization: Plexity Networks
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 23 2007, at 20:37, Matthieu CASTET was caught saying:
> Hi,
> 
> Deepak Saxena <dsaxena <at> plexity.net> writes:
> 
> > 
> > 
> > This patch contains a set of small fixes to allow the kernel to build under
> > the Cygwin environment, which is unfortunately used by more people than
> > one would think in the embedded world. :(
> Yes, I did similar patch, and there are needed for everything (busybox, 
> glibc, ...)
>                         -D LKC_DIRECT_LINK
> > 
> > +HOST_OS := $(shell uname -o)
> > +ifeq ($(HOST_OS),Cygwin)
> > +HOSTLOADLIBES_mconf	= -lintl
> > +HOSTLOADLIBES_conf	= -lintl
> > +endif
> > +
> Hum, this test should be done if we detect nls support. See ifeq
> ($(KBUILD_HAVE_NLS),no) ...

OK, will do. I'm running into the same issue trying to fix building
under uclibc and would defintely be nicer to have a single solution.

~Deepak

-- 
Deepak Saxena - dsaxena@plexity.net - http://www.plexity.net

In the end, they will not say, "those were dark times,"  they will ask
"why were their poets silent?" - Bertolt Brecht
