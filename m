Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbZD2NqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbZD2NqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbZD2Np7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:45:59 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:36307 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbZD2Np6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:45:58 -0400
Date: Wed, 29 Apr 2009 09:44:53 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Jiri Kosina <jkosina@suse.cz>
cc: hannes@cmpxchg.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: how to properly post/disseminate kernel cleanup/janitorial
 possibilities?
In-Reply-To: <alpine.LNX.2.00.0904291400200.5012@wotan.suse.de>
Message-ID: <alpine.LFD.2.00.0904290938310.5304@localhost.localdomain>
References: <alpine.LFD.2.00.0904271637470.4906@localhost.localdomain> <20090427222035.GA2700@cmpxchg.org> <alpine.LNX.2.00.0904281024150.5012@wotan.suse.de> <alpine.LFD.2.00.0904280619590.16989@localhost.localdomain>
 <alpine.LNX.2.00.0904291400200.5012@wotan.suse.de>
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

On Wed, 29 Apr 2009, Jiri Kosina wrote:

> On Tue, 28 Apr 2009, Robert P. J. Day wrote:
>
> > > > Perhaps Jiri can pick up some of the patches that remove stale
> > > > config symbols, correct typos etc.

> > > Absolutely. I'll happily apply anything trivial enough (typo fixes,
> > > removal of obviously unused symbols/config options, etc).

> > the *problem* is that, sometimes, it's not obvious.  as in, when a
> > Kconfig file has a pile of unused config options but it turns out
> > that those were added for future consideration to match up with
> > code that hasn't been added yet and the subsystem maintainer knows
> > about it but wants it to stay (IMHO, a really bad idea -- adding
> > kernel features in incomplete pieces, but whatever).
>
> Hmm ... do you have any particular outstanding examples of this?

  historically, plenty, based on the number of times i've submitted
patches to various maintainers to remove unused symbols, only to be
told that those symbols were added in a preliminary fashion, and the
accompanying code should be along any day now.  obviously, that
doesn't cause any actual problems but it certainly messes up the
history of a feature by breaking its introduction over more than one
patch.

  and as for *current* examples, well, there's this page:

http://www.crashcourse.ca/wiki/index.php/Unused_CONFIG_variables

one recent example was MAC80211_VERBOSE_SPECT_MGMT_DEBUG, if you
wanted an actual reference.

  really, i'm *aware* that 99% of this scanning and cleanup is benign.
but that final 1% sometimes really does represent a bug and, since i
have the scripts and it's pretty much free to run them whenever i
want, we're back to the original question -- what's the best venue to
distribute this info so as not to bore to tears the people who don't
care about it?

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
