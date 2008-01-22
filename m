Return-Path: <linux-kernel-owner+w=401wt.eu-S1760257AbYAVA5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760257AbYAVA5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 19:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755284AbYAVA5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 19:57:47 -0500
Received: from pip9.gyao.ne.jp ([61.122.117.247]:31698 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753129AbYAVA5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 19:57:45 -0500
Date: Tue, 22 Jan 2008 09:56:57 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andreas Schwab <schwab@suse.de>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, linux-arch@vger.kernel.org,
       Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] Use separate sections for __dev/__cpu/__mem code/data
Message-ID: <20080122005657.GA26831@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Sam Ravnborg <sam@ravnborg.org>, Andreas Schwab <schwab@suse.de>,
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org, Greg KH <greg@kroah.com>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Adrian Bunk <bunk@kernel.org>
References: <1200859743-24037-6-git-send-email-sam@ravnborg.org> <1200859743-24037-7-git-send-email-sam@ravnborg.org> <1200859743-24037-8-git-send-email-sam@ravnborg.org> <20080121073341.GA20050@linux-sh.org> <20080121095722.GA29145@uranus.ravnborg.org> <jebq7fqxnj.fsf@sykes.suse.de> <20080121104506.GA29585@uranus.ravnborg.org> <20080121104745.GA29721@uranus.ravnborg.org> <20080121105257.GA21567@linux-sh.org> <20080121120641.GA30165@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080121120641.GA30165@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2008 at 01:06:41PM +0100, Sam Ravnborg wrote:
> On Mon, Jan 21, 2008 at 07:52:57PM +0900, Paul Mundt wrote:
> > On Mon, Jan 21, 2008 at 11:47:45AM +0100, Sam Ravnborg wrote:
> > > On Mon, Jan 21, 2008 at 11:45:06AM +0100, Sam Ravnborg wrote:
> > > > On Mon, Jan 21, 2008 at 11:29:52AM +0100, Andreas Schwab wrote:
> > > > > Sam Ravnborg <sam@ravnborg.org> writes:
> > > > > 
> > > > > > On Mon, Jan 21, 2008 at 04:33:41PM +0900, Paul Mundt wrote:
> > > > > >> so the ## is being taken directly rather than acting as a concatenation.
> > > > > >
> > > > > > Strange...
> > > > > > I can reproduce with gcc 3.4.5 here - will fix.
> > > > > 
> > > > > The ## operator does not work with -traditional.
> > > > 
> > > > Crap - then it breaks at the following architectures:
> > > > sh64, s390, m68k, m32r
> > > > 
> > > > Thanks Andreas.
> > > 
> > > OK - I was too quick it seem.
> > > sh has:
> > > arch/sh/Makefile:CPPFLAGS_vmlinux.lds := -traditional
> > > 
> > > So this needs to be ripped out as it is not needed.
> > > 
> > Yes, that can be killed. If this is aimed at 2.6.25, I'll just kill it
> > off in my tree. Otherwise, feel free to roll this in to your patch set.
> 
> It is aimed for 2.6.25 and it looks reasonable to reach that goal.
> So please take this patch in your tree.
> 
Done.
