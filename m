Return-Path: <linux-kernel-owner+w=401wt.eu-S1759374AbZFBF72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374AbZFBF72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 01:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753565AbZFBF7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 01:59:20 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:48584
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbZFBF7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 01:59:20 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] update kernel's scripts/bloat-o-meter from busybox
Date: Tue, 2 Jun 2009 00:59:17 -0500
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; x86_64; ; )
Cc: Robin Getz <rgetz@blackfin.uclinux.org>, Sam Ravnborg <sam@ravnborg.org>,
       "Bernhard Reutner-Fischer" <rep.dot.nop@gmail.com>,
       Denis Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org
References: <200906011526.01108.rgetz@blackfin.uclinux.org> <1243885732.22069.112.camel@calx>
In-Reply-To: <1243885732.22069.112.camel@calx>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906020059.18603.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 June 2009 14:48:52 Matt Mackall wrote:
> On Mon, 2009-06-01 at 15:26 -0400, Robin Getz wrote:
> > From: "Rob Landley" <rob@landley.net>
> > From: "Denis Vlasenko" <vda.linux@googlemail.com>
> > From: "Bernhard Reutner-Fischer" <rep.dot.nop@gmail.com>
> >
> > Since bloat-o-meter was added to the kernel's source tree, it has
> > received little attention - either it works really well - or no one uses
> > it. I suspect the first :)
> >
> > However - some folks who have been using it more (mainly as part of
> > busybox) have been poking at it more often - and the output is a little
> > more friendly now.
> >
> > http://git.busybox.net/busybox/log/scripts/bloat-o-meter
> >
> > I think Rob had been sending early patches both places, but somewhere
> > along the line things never made it to lkml.
>
> I probably dropped them on the ground during a busy spell.

Nah, the patches I sent got applied, I just haven't messed with it in the past 
couple years.  So you don't need my signed-off-by, but I'm happy to give you 
an:

Acked-by: Rob Landley <rob@landley.net>

This was actually a series of five patches in the busybox repository, with 
descriptions.  Unfortunately, they recently converted the repository to git.  
Here are the big not remotely human readable git commit tags:

2425bdce34cd142b29eabad00927a9c473b05ecb
45aebfd32d30de492c6c714cd5b6a08ae4a53867
49bdf28c320bf4e02048eb0cbd115d84b8467cd9
7bd8d8fd264a72f9c228da3ca238eae1b2ad8ce1
cf575ca8561c53ef8299e9efcebb9dce96de2ff0

And the repository's at git://busybox.net/busybox.git


Rob

P.S.  I'd attach the 5 patch+descriptions, but I just spent fifteen minutes 
fighting with git to try to convince "git log -p" that when I list a specific 
commit on the command line I want it to spit out the description and patch for 
JUST THAT ONE COMMIT and not log the history back to Grace Hopper's graduation 
ceremony, and I ran out of interest before git ran out of ways to have a 
horrible user interface and man pages written by Tolstoy.  The man page for 
git-log is 1047 lines long, describing in horrific detail things I don't want 
it to do.  I gave up reading it about the point it started describing "parent 
rewriting", and went to google instead.  Google for "git log single patch" 
implies I should have a command named git-format-patch, which Xubuntu didn't 
install when I asked for git-core, and which I'm not hunting down right now...
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
