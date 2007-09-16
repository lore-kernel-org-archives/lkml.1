Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbXIPUhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbXIPUhb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 16:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbXIPUhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 16:37:24 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51066 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbXIPUhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 16:37:24 -0400
Date: Sun, 16 Sep 2007 22:38:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild update
Message-ID: <20070916203848.GA10365@uranus.ravnborg.org>
References: <20070916094739.GA6672@uranus.ravnborg.org> <Pine.LNX.4.64.0709160856060.20489@localhost.localdomain> <20070916122343.59e8885d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070916122343.59e8885d.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2007 at 12:23:43PM -0700, Andrew Morton wrote:
> On Sun, 16 Sep 2007 08:58:03 -0400 (EDT) "Robert P. J. Day" <rpjday@mindspring.com> wrote:
> 
> > On Sun, 16 Sep 2007, Sam Ravnborg wrote:
> > 
> > > A summary of what is planned to be submitted in next merge window for kbuild.
> > > The shortlog below have additional details but the headlines are:
> > ...
> > > o add script to find unused kconfig symbols (try it!)
> > 
> > based on my experiences with this, unless you filter carefully, you're
> > going to end up with a *whack* of false positives given the number of
> > developers who elect to name their local macros starting with a prefix
> > of "CONFIG_".  good luck dealing with *that*.  :-)
> 
> box:/usr/src/linux-2.6.23-rc6> grep -r '^[      ]*#[    ]*define[       ]*CONFIG_' . | wc -l
> 415
> 
> bah.  They're all bugs - The CONFIG_foo namespace is (should be) reserved in
> kernel coding.

I get (after a bit more filtering 349 hits of which 182 are outside drivers/

Of the 182 the 25 of them are in arch specific code.

I se no good reasons to address this unless we touch code in that area anyway.
But avoiding new entries are good.

	Sam

