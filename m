Return-Path: <linux-kernel-owner+w=401wt.eu-S1760030AbYAUKrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760030AbYAUKrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:47:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759078AbYAUKri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:47:38 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:40697 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759040AbYAUKrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:47:36 -0500
Date: Mon, 21 Jan 2008 11:47:45 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andreas Schwab <schwab@suse.de>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, linux-arch@vger.kernel.org,
       Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] Use separate sections for __dev/__cpu/__mem code/data
Message-ID: <20080121104745.GA29721@uranus.ravnborg.org>
References: <1200859743-24037-3-git-send-email-sam@ravnborg.org> <1200859743-24037-4-git-send-email-sam@ravnborg.org> <1200859743-24037-5-git-send-email-sam@ravnborg.org> <1200859743-24037-6-git-send-email-sam@ravnborg.org> <1200859743-24037-7-git-send-email-sam@ravnborg.org> <1200859743-24037-8-git-send-email-sam@ravnborg.org> <20080121073341.GA20050@linux-sh.org> <20080121095722.GA29145@uranus.ravnborg.org> <jebq7fqxnj.fsf@sykes.suse.de> <20080121104506.GA29585@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080121104506.GA29585@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2008 at 11:45:06AM +0100, Sam Ravnborg wrote:
> On Mon, Jan 21, 2008 at 11:29:52AM +0100, Andreas Schwab wrote:
> > Sam Ravnborg <sam@ravnborg.org> writes:
> > 
> > > On Mon, Jan 21, 2008 at 04:33:41PM +0900, Paul Mundt wrote:
> > >> so the ## is being taken directly rather than acting as a concatenation.
> > >
> > > Strange...
> > > I can reproduce with gcc 3.4.5 here - will fix.
> > 
> > The ## operator does not work with -traditional.
> 
> Crap - then it breaks at the following architectures:
> sh64, s390, m68k, m32r
> 
> Thanks Andreas.

OK - I was too quick it seem.
sh has:
arch/sh/Makefile:CPPFLAGS_vmlinux.lds := -traditional

So this needs to be ripped out as it is not needed.

	Sam
