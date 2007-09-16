Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbXIPPL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbXIPPL6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 11:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbXIPPLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 11:11:52 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:52477 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbXIPPLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 11:11:51 -0400
Date: Sun, 16 Sep 2007 17:13:14 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kbuild update
Message-ID: <20070916151314.GB7435@uranus.ravnborg.org>
References: <20070916094739.GA6672@uranus.ravnborg.org> <Pine.LNX.4.64.0709160856060.20489@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709160856060.20489@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2007 at 08:58:03AM -0400, Robert P. J. Day wrote:
> On Sun, 16 Sep 2007, Sam Ravnborg wrote:
> 
> > A summary of what is planned to be submitted in next merge window for kbuild.
> > The shortlog below have additional details but the headlines are:
> ...
> > o add script to find unused kconfig symbols (try it!)
> 
> based on my experiences with this, unless you filter carefully, you're
> going to end up with a *whack* of false positives given the number of
> developers who elect to name their local macros starting with a prefix
> of "CONFIG_".  good luck dealing with *that*.  :-)
This is useful for specific people but not for kernel janitorial fodder.
As you already experience the amount of false positive are too high.

But for a developer of a module it is no deal to ignore the false
positives.

It is for godd reasons not integrated in the build process.

	Sam
