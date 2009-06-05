Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbZFEUU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbZFEUU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 16:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbZFEUUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 16:20:49 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:40801 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbZFEUUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 16:20:48 -0400
Date: Fri, 5 Jun 2009 16:17:52 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Russell King <rmk+lkml@arm.linux.org.uk>
cc: Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Catalin Marinas <catalin.marinas@arm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 1/6] headers_check fix: arm, hwcap.h
In-Reply-To: <20090605201001.GA17085@flint.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.00.0906051616001.5200@localhost.localdomain>
References: <1244118232.5172.26.camel@ht.satnam> <1244118476.5172.29.camel@ht.satnam> <20090604125306.GC24491@flint.arm.linux.org.uk> <20090604201649.GC13892@uranus.ravnborg.org> <20090605201001.GA17085@flint.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jun 2009, Russell King wrote:

> On Thu, Jun 04, 2009 at 10:16:49PM +0200, Sam Ravnborg wrote:
> > On Thu, Jun 04, 2009 at 01:53:07PM +0100, Russell King wrote:
> > > On Thu, Jun 04, 2009 at 05:57:56PM +0530, Jaswinder Singh Rajput wrote:
> > > > fix the following 'make headers_check' warning:
> > >
> > > I think headers_check needs fixing - there's nothing wrong with the
> > > code as it presently stands except the tools obviously can't properly
> > > parse C preprocessor statements.
> >
> > You are correct that headers_ceck is limited here and this patch
> > take some valid code and refactor it to make it headers_check compatible.
>
> If it is just a matter of unifdef not doing the right thing, then
> that's a bug in unifdef - looking at the code, it _should_ handle
> the case as it's currently in the tree.

  the current version of unifdef, as it stands, has some weaknesses.
there's a newer version -- sunifdef -- that appears to be more robust
and ruthless when it comes to cleaning.  just an observation.

http://www.sunifdef.strudl.org/

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
