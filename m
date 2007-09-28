Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbXI1TXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbXI1TXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 15:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbXI1TXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 15:23:08 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:38276 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbXI1TXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 15:23:07 -0400
Date: Fri, 28 Sep 2007 21:24:34 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Milton Miller <miltonm@bga.com>
Cc: Kai Germaschewski <kai@germaschewski.name>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH Kbuild] Call only one make with all targets for O=
Message-ID: <20070928192434.GA10769@uranus.ravnborg.org>
References: <kbuild-8-00.miltonm@bga.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <kbuild-8-00.miltonm@bga.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 06:09:02PM -0500, Milton Miller wrote:
> Change the invocations of make in the output directory Makefile and the
> main Makefile for seperate object trees to pass all goals to one $(MAKE)
> via a new phony target "sub-make" and the existing target _all.
> 
> When compiling with seperate object directories, a seperate make is called
> in the context of another directory (from the output directory the main
> Makefile is called, the Makefile is then restarted with current directory
> set to the object tree).  Before this patch, when multiple make command
> goals are specified, each target results in a seperate make invocation.
> With make -j, these invocations may run in parallel, resulting in multiple
> commands running in the same directory clobbering each others results.
> 
> I did not try to address make -j for mixed dot-config and no-dot-config
> targets.  Because the order does matter, a solution was not obvious.
> Perhaps a simple check for MAKEFLAGS having -j and refusing to run would
> be approprate.

Applied to kbuild.git.

This was a nice one to get ruined out.
Thanks Milton,

	Sam
