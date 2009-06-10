Return-Path: <linux-kernel-owner+w=401wt.eu-S1759715AbZFJPV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759715AbZFJPV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 11:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757441AbZFJPVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 11:21:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:56895 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758499AbZFJPVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 11:21:18 -0400
Subject: Re: [git-pull -tip] headers_check fix patches 20090610
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@snapgear.com>, David Howells <dhowells@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090611001957.61b5530b.sfr@canb.auug.org.au>
References: <1244640630.20890.22.camel@ht.satnam>
	 <20090611001957.61b5530b.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Wed, 10 Jun 2009 20:49:36 +0530
Message-Id: <1244647176.3070.8.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stephen,

On Thu, 2009-06-11 at 00:19 +1000, Stephen Rothwell wrote:
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
> Is there some reason that these fixes are not just sent to the appropriate
> maintainers?  That way we would avoid unnecessary conflicts cropping up.
> 

Maintainers are also in CC.
Patches were already sent on :

Subject: [PATCH 0/6] headers_check fix patches 20090604

Interested maintainers already pulled and applied patches. These are
left-over patches. I am sending to Ingo hoping that he will merge it
otherwise last option for me will be to prepare headers-check tree and
send to linux-next ;-)

Thanks,
--
JSR

