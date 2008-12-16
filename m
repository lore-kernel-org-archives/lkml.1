Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbYLPLPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbYLPLPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 06:15:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbYLPLPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 06:15:40 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50650 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729AbYLPLPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 06:15:39 -0500
Date: Tue, 16 Dec 2008 09:15:01 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, David Miller <davem@davemloft.net>,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       mingo@elte.hu
Subject: Re: Impact: (was Re: [PATCH] update rwlock initialization for
	nat_table)
Message-ID: <20081216111501.GH14518@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	David Miller <davem@davemloft.net>, rostedt@goodmis.org,
	linux-kernel@vger.kernel.org, dada1@cosmosbay.com, mingo@elte.hu
References: <alpine.DEB.1.10.0812101314460.11805@gandalf.stny.rr.com> <49400B7F.7040607@cosmosbay.com> <alpine.DEB.1.10.0812101504280.11805@gandalf.stny.rr.com> <20081215.002019.232912990.davem@davemloft.net> <20081216011039.GA2458@x200.localdomain> <20081215171935.42a44d0d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081215171935.42a44d0d.akpm@linux-foundation.org>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 15, 2008 at 05:19:35PM -0800, Andrew Morton escreveu:
> On Tue, 16 Dec 2008 04:10:39 +0300 Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > Speaking of Impact: lines, is this a new fashion or what?
> > 
> > Looking at the ones which are already in official tree, they are either
> > trivially duplicating Subject: line, or effectively duplicating Subject: line,
> > or cover up for insufficiently informative (read: badly written) Subject: line,
> > or simply useless.
> > 
> > 
> > 	Subject: sched: CPU remove deadlock fix
> > 	Impact: fix possible deadlock in CPU hot-remove path
> > 
> > What prevented to write "Subject: sched: fix possible deadlock in CPU hot-remove path"?
> > 
> > 
> > 	AMD IOMMU: __unmap_single: check for bad_dma_address instead of 0
> > 	Impact: minor fix
> > 
> > Well...
> > 
> > I have an idea on how to make them remotely useful, but can we agree that there is
> > a problem arising here?
> 
> heh, I must say that the ones I've seen haven't been very useful.
> 
> However...  Given the amount of time I (and others, to a lesser extent)
> spend complaining about and scratching heads over crappy changelogs, we
> would benefit from having a standard changelog template.
> 
> Something which guides people to creating a good changelog.  But it
> would have to be short, and carefully written.  It should learn from
> history, to wit:
> 
> - ./REPORTING-BUGS has a template and afaik it has never elicited any
>   useful information.
> 
> - Documentation/SubmittingPatches has info on how to write a
>   changelog, and people blithely ignore it.
> 
> - kerneldoc provide a template of sorts, and we see that filling out
>   templates puts people's brains into "filling out a template" mode,
>   rather than into "communicating information" mode.
> 
> An interesting problem.

Well, if git commit could add that template in addition to the
Signed-off-by line, that could be a start, perhaps as a new option and
then it would get it from .git/changelog-template, that would be
provided by each project.

/me scratches head...

    -t, --template <FILE>
                              use specified template file

Its there already, but then perhaps what is needed is a _default_
template.

- Arnaldo
