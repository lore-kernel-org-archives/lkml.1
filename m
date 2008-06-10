Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbYFJTGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbYFJTGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 15:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754971AbYFJTGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 15:06:30 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:54027 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603AbYFJTG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 15:06:29 -0400
Date: Tue, 10 Jun 2008 22:05:30 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Bird <tim.bird@am.sony.com>, Rob Landley <rob@landley.net>,
       linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: mainlining min-configs...
Message-ID: <20080610190530.GH11685@cs181133002.pp.htv.fi>
References: <48447615.5050806@am.sony.com> <20080604194002.GF4189@cs181133002.pp.htv.fi> <4849CCA3.7040102@am.sony.com> <200806062329.54019.rob@landley.net> <484DDAD9.2000306@am.sony.com> <20080610083610.GC1987@cs181133002.pp.htv.fi> <484EC576.5080302@am.sony.com> <20080610183004.GG11685@cs181133002.pp.htv.fi> <20080610185123.GA15838@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080610185123.GA15838@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 08:51:23PM +0200, Sam Ravnborg wrote:
> On Tue, Jun 10, 2008 at 09:30:04PM +0300, Adrian Bunk wrote:
> > On Tue, Jun 10, 2008 at 11:18:30AM -0700, Tim Bird wrote:
> > > Adrian Bunk wrote:
> > >...
> > > > You need both, and ideally constantly done by the same person against 
> > > > Linus' tree, -next and -mm.
> > > > 
> > > > Where to get your minimal configs from at the start is just a small 
> > > > thing at the beginning - don't underestimate the required manual work 
> > > > that will have to be done each week.
> > > 
> > > This is probably why I haven't signed up for this myself previously.
> > > I'd be interested in finding out the rate at which defconfigs
> > > bitrot in mainline.  My experience is that usually a 'make oldconfig'
> > > will produce something usable.  But maybe that wouldn't be as
> > > effective with a minconfig?
> > >...
> > 
> > Someone has to run the 'make oldconfig' for all configs...
> > 
> > And no, you cannot get that completely automated.
> 
> When I get my kconfig patchset polished you will be able to do:
> 
> make K=my_mini_config allnoconfig

  make KCONFIG_ALLCONFIG=my_mini_config allnoconfig

already does the same.

> Thus selecting 'no' for all new symbols in an automated fashion.
> I know that in a few cases 'no' is the wrong answer but in the
> 99% of the cases 'no' is perfectly valid.

The 1% contain cases like e.g. a kconfig variable you need getting
a new dependency.

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

