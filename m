Return-Path: <linux-kernel-owner+w=401wt.eu-S1760298AbZEHKdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760298AbZEHKdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 06:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbZEHKdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 06:33:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48302 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbZEHKde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 06:33:34 -0400
Date: Fri, 8 May 2009 07:32:39 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       greg@kroah.com, norsk5@yahoo.com, tglx@linutronix.de, hpa@zytor.com,
       aris@redhat.com, edt@aei.ca, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/21 v3] amd64_edac: EDAC module for AMD64
Message-ID: <20090508073239.4d04c0d7@pedra.chehab.org>
In-Reply-To: <20090508100738.GA21064@aftab>
References: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
	<20090507142724.GM481@elte.hu>
	<20090507143807.GA15923@aftab>
	<20090507135227.abbbc7dc.akpm@linux-foundation.org>
	<20090507211859.GA28770@elte.hu>
	<20090508100738.GA21064@aftab>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 8 May 2009 12:07:38 +0200
Borislav Petkov <borislav.petkov@amd.com> escreveu:

> Hi,
> 
> On Thu, May 07, 2009 at 11:18:59PM +0200, Ingo Molnar wrote:
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Thu, 7 May 2009 16:38:07 +0200
> > > Borislav Petkov <borislav.petkov@amd.com> wrote:
> > > 
> > > > Hi,
> > > > 
> > > > On Thu, May 07, 2009 at 04:27:24PM +0200, Ingo Molnar wrote:
> > > > > Regarding workflow, the arch/x86 bits look good to me now, so you've 
> > > > > got my Acked-by for that.
> > > > 
> > > > Cool, thanks.
> > > > 
> > > > Does that mean you're going to pick that one or...
> > > > 
> > > > > Most of the EDAC patches are hosted in 
> > > > > -mm, so we could carry them in the x86 tree separately as well and 
> > > > > export it to linux-next so that -mm will have it automatically.
> > > > 
> > > > is the bunch going through Andrew as a whole?
> > > > 
> > > 
> > > I could.  But there's negligible overlap with other EDAC work so 
> > > we might as well merge this via IngoTrees or directly from your 
> > > tree.
> > 
> > If Doug and you agrees too then i have no problem (at all) with 
> > Borislav carrying these bits in a separate tree, as long as he also 
> > opens an edac-next branch for linux-next and asks Stephen to pull 
> > it, and keeps it an append-mostly tree that isnt rebased.
> 
> I'll still need to rebase stuff to latest Linus tree for now since we're
> not yet ready reorganizing/cleaning up the code. After it gets merged,
> I'll switch to append-only mode.

One good idea is to split the Kbuild changes into a separate changeset. This
way, if compilation happens to break due to a merge conflict with other patches,
you can just write a fix patch fixing it before the Kbuild one, without
breaking git bisect.

-- 

Cheers,
Mauro
