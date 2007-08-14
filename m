Return-Path: <linux-kernel-owner+w=401wt.eu-S1765265AbXHNRAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765265AbXHNRAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 13:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763402AbXHNRAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 13:00:34 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4665 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760732AbXHNRAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 13:00:32 -0400
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch -
	scripts/get_maintainer.pl
From: Joe Perches <joe@perches.com>
To: Rene Herman <rene.herman@gmail.com>, git@vger.kernel.org,
       Junio C Hamano <gitster@pobox.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
In-Reply-To: <46C1CFFE.4000001@gmail.com>
References: <1186984174.10249.7.camel@localhost>
	 <200708131933.10125.m.kozlowski@tuxland.pl>
	 <1187026955.2688.4.camel@laptopd505.fenrus.org>
	 <1187037445.6628.98.camel@heimdal.trondhjem.org>
	 <1187054366.2757.0.camel@laptopd505.fenrus.org>
	 <46C10AA8.3090505@gmail.com> <20070814102033.604c8695@the-village.bc.nu>
	 <46C1CFFE.4000001@gmail.com>
Content-Type: text/plain
Date: Tue, 14 Aug 2007 10:00:24 -0700
Message-Id: <1187110824.32555.76.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-14 at 17:53 +0200, Rene Herman wrote:
> It isn't about MODULE_FOO() tags, it is about tagging /source/ files 
> to help with putting CCs on patch submissals.
> If we want to link source file foo.c and the 
> MAINTAINERS information, we have 3 options:
> 1. MAINTAINERS --> foo.c
> 2. foo.c --> MAINTAINERS
> 3. foo.c <--> some 3rd file <--> MAINTAINERS

I added git@vger.kernel.org and Junio Hamano

Another possibility is improving git to allow
some sort of "declaration of interest" in bits
of projects.

That would allow options like:

o  git-format-patch to include CCs
o  git-commit and git-branch to notify or
     take some other action

etc...

It's generic, applies to multiple projects, etc.

I don't care which mechanism is used, I just want
to be able to CC appropriate people and lists on
changes to their areas of interest without wasting
time searching all over the place per file changed.

The LK MAINTAINERS file is weakly specified, but
I'm not a git-geek, nor do I want to be one, so
MAINTAINERS was the file I could easiest change
with minimal impact to LK sources.

The get_maintainer script is trivial,
I'm not wedded to it at all.

