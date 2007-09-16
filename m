Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbXIPPYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbXIPPYQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 11:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbXIPPYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 11:24:00 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:36069 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbXIPPX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 11:23:59 -0400
X-Originating-Ip: 72.143.66.27
Date: Sun, 16 Sep 2007 11:21:59 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Sam Ravnborg <sam@ravnborg.org>
cc: kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kbuild update
In-Reply-To: <20070916151314.GB7435@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0709161118370.27142@localhost.localdomain>
References: <20070916094739.GA6672@uranus.ravnborg.org>
 <Pine.LNX.4.64.0709160856060.20489@localhost.localdomain>
 <20070916151314.GB7435@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.723, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	TW_VN 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Sep 2007, Sam Ravnborg wrote:

> On Sun, Sep 16, 2007 at 08:58:03AM -0400, Robert P. J. Day wrote:
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

> This is useful for specific people but not for kernel janitorial
> fodder. As you already experience the amount of false positive are
> too high.
>
> But for a developer of a module it is no deal to ignore the false
> positives.
>
> It is for godd reasons not integrated in the build process.

right, i agree completely.  if it were absolutely reliable in
generating *only* actual unused symbols, then that *might* (i stress,
*might*) be a viable argument for making it part of the Kbuild system.

but, really, if you can whip off a script that does most of the job in
a few minutes, there's really no motivation to then spend hours trying
to nail those last few harmless bits of irrelevant output.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
