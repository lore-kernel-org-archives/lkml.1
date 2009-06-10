Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbZFJPTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbZFJPTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 11:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755308AbZFJPTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 11:19:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48169 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754937AbZFJPTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 11:19:04 -0400
Date: Wed, 10 Jun 2009 17:17:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@snapgear.com>, David Howells <dhowells@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] headers_check fix patches 20090610
Message-ID: <20090610151721.GB19004@elte.hu>
References: <1244640630.20890.22.camel@ht.satnam> <20090611001957.61b5530b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611001957.61b5530b.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Jaswinder,
> 
> On Wed, 10 Jun 2009 19:00:30 +0530 Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> >
> > The following changes since commit e271e1343a94e081723cb4180af3fdb5fecc1a49:
> >   Ingo Molnar (1):
> >         Merge branch 'x86/mce4'
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-top.git master
> > 
> > Jaswinder Singh Rajput (3):
> >       headers_check fix: m68k, swab.h
> >       headers_check fix: mn10300, ptrace.h
> >       headers_check fix: mn10300, setup.h
> > 
> >  arch/m68k/include/asm/swab.h      |    2 +-
> >  arch/mn10300/include/asm/ptrace.h |    5 ++---
> >  arch/mn10300/include/asm/setup.h  |    3 ++-
> >  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> Is there some reason that these fixes are not just sent to the 
> appropriate maintainers?  That way we would avoid unnecessary 
> conflicts cropping up.

Yes, that is what should happen. The initial header fixes going via 
-tip was really a one-off effort due to the sheer mass of the 
changes needed and due to the concentrated review effort that was 
done by many people. Now the patches can go via the usual maintainer 
channels.

	Ingo
