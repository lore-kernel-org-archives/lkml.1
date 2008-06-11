Return-Path: <linux-kernel-owner+w=401wt.eu-S1758854AbYFKFJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbYFKFJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 01:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbYFKFJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 01:09:27 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:38611
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbYFKFJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 01:09:26 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: mainlining min-configs...
Date: Wed, 11 Jun 2008 00:09:22 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Adrian Bunk <bunk@kernel.org>, Tim Bird <tim.bird@am.sony.com>,
       linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
References: <48447615.5050806@am.sony.com> <20080610183004.GG11685@cs181133002.pp.htv.fi> <20080610185123.GA15838@uranus.ravnborg.org>
In-Reply-To: <20080610185123.GA15838@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806110009.22542.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 June 2008 13:51:23 Sam Ravnborg wrote:
> On Tue, Jun 10, 2008 at 09:30:04PM +0300, Adrian Bunk wrote:
> > On Tue, Jun 10, 2008 at 11:18:30AM -0700, Tim Bird wrote:
> > > Adrian Bunk wrote:
> > >...
> > >
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

So you're renaming KCONFIG_ALLNOCONFIG then?

> Thus selecting 'no' for all new symbols in an automated fashion.
> I know that in a few cases 'no' is the wrong answer but in the
> 99% of the cases 'no' is perfectly valid.

For a "make miniconfig", warnings should be errors.  (Attempts to set unknown 
symbols are an error with a miniconfig, the operation should exit with a 
nonzero error code.)  Also, all the stuff allnoconfig puts to stdout 
shouldn't be there for miniconfig, only the stuff it writes to stderr right 
now should show up.

I think I did more than that, but I'd have to look at my old patches...

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
