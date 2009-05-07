Return-Path: <linux-kernel-owner+w=401wt.eu-S1758529AbZEGVU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529AbZEGVU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 17:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbZEGVUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 17:20:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36521 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbZEGVUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 17:20:12 -0400
Date: Thu, 7 May 2009 23:18:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <borislav.petkov@amd.com>, greg@kroah.com,
       norsk5@yahoo.com, tglx@linutronix.de, hpa@zytor.com, mchehab@redhat.com,
       aris@redhat.com, edt@aei.ca, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/21 v3] amd64_edac: EDAC module for AMD64
Message-ID: <20090507211859.GA28770@elte.hu>
References: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com> <20090507142724.GM481@elte.hu> <20090507143807.GA15923@aftab> <20090507135227.abbbc7dc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507135227.abbbc7dc.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 7 May 2009 16:38:07 +0200
> Borislav Petkov <borislav.petkov@amd.com> wrote:
> 
> > Hi,
> > 
> > On Thu, May 07, 2009 at 04:27:24PM +0200, Ingo Molnar wrote:
> > > Regarding workflow, the arch/x86 bits look good to me now, so you've 
> > > got my Acked-by for that.
> > 
> > Cool, thanks.
> > 
> > Does that mean you're going to pick that one or...
> > 
> > > Most of the EDAC patches are hosted in 
> > > -mm, so we could carry them in the x86 tree separately as well and 
> > > export it to linux-next so that -mm will have it automatically.
> > 
> > is the bunch going through Andrew as a whole?
> > 
> 
> I could.  But there's negligible overlap with other EDAC work so 
> we might as well merge this via IngoTrees or directly from your 
> tree.

If Doug and you agrees too then i have no problem (at all) with 
Borislav carrying these bits in a separate tree, as long as he also 
opens an edac-next branch for linux-next and asks Stephen to pull 
it, and keeps it an append-mostly tree that isnt rebased.

[ I still have to do a finegrained review of this lot, a quick look
  suggested i'll have a few minor things to note ;) ]

	Ingo
