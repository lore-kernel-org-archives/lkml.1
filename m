Return-Path: <linux-kernel-owner+w=401wt.eu-S935100AbXHMVOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935100AbXHMVOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 17:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939794AbXHMVMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 17:12:49 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:26745 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933987AbXHMVMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 17:12:47 -0400
Date: Mon, 13 Aug 2007 14:17:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       sam@ravnborg.org, zippel@linux-m68k.org, vincent.legoll@gmail.com
Subject: Re: [-mm patch] kconfig syntax cleanups
Message-Id: <20070813141701.446990cb.randy.dunlap@oracle.com>
In-Reply-To: <20070813200509.GF18945@stusta.de>
References: <20070813113809.9a715e75.randy.dunlap@oracle.com>
	<20070813185431.GD18945@stusta.de>
	<Pine.LNX.4.64.0708131510140.14058@localhost.localdomain>
	<20070813200509.GF18945@stusta.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007 22:05:10 +0200 Adrian Bunk wrote:

> On Mon, Aug 13, 2007 at 03:13:30PM -0400, Robert P. J. Day wrote:
> > On Mon, 13 Aug 2007, Adrian Bunk wrote:
> > 
> > > On Mon, Aug 13, 2007 at 11:38:09AM -0700, Randy Dunlap wrote:
> > > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > > >
> > > > Add kconfig-language docs for mainmenu, def_bool[ean],
> > > > and def_tristate.
> > > >
> > > > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > > > Signed-off-by: Vincent Legoll <vincent.legoll@gmail.com>
> > > > ---
> > > >  Documentation/kbuild/kconfig-language.txt |   12 ++++++++++++
> > > >  1 file changed, 12 insertions(+)
> > > >
> > > > --- linux-2.6.23-rc3.orig/Documentation/kbuild/kconfig-language.txt
> > > > +++ linux-2.6.23-rc3/Documentation/kbuild/kconfig-language.txt
> > > > @@ -77,6 +77,11 @@ applicable everywhere (see syntax).
> > > >    Optionally, dependencies only for this default value can be added with
> > > >    "if".
> > > >
> > > > +- type definition + default value:
> > > > +	"def_bool"/"def_boolean"/"def_tristate" <expr> ["if" <expr>]
> > > >...
> > >
> > > Should the redundant and unused def_boolean be documented or removed?
> > >
> > > I'd prefer the latter.
> > 
> > me too.  and, as i've suggested before, it would also be cleaner to
> > remove the redundant "requires" and almost redundant "depends" from
> > Kconfig files, and standardize exclusively on "depends on".
> >...
> 
> Patch below.
> 
> > rday
> 
> cu
> Adrian
> 
> 
> <--  snip  -->
> 
> 
> This patch removes the following redundant and never or rarely used 
> kconfig syntax:
> - "def_boolean" (same as "def_bool")
> - "requires" (same as "depends on")
> - "depends" (same as "depends on")
> 
> Most of the size of this patch comes from regenerating generated files.

Looks OK to me.

Missing S-O-B line...


> ---
> 
>  arch/blackfin/Kconfig                |    2 
>  arch/powerpc/Kconfig.debug           |    6 
>  arch/powerpc/platforms/Kconfig       |    2 
>  drivers/input/misc/Kconfig           |    2 
>  drivers/leds/Kconfig                 |    2 
>  drivers/telephony/Kconfig            |    2 
>  net/wireless/Kconfig                 |    2 
>  scripts/kconfig/lex.zconf.c_shipped  |    4 
>  scripts/kconfig/zconf.gperf          |    2 
>  scripts/kconfig/zconf.hash.c_shipped |  223 ++--
>  scripts/kconfig/zconf.tab.c_shipped  | 1406 ++++++++++++++-------------
>  scripts/kconfig/zconf.y              |   11 
>  12 files changed, 889 insertions(+), 775 deletions(-)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
