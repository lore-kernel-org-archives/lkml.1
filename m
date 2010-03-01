Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751013Ab0CAJB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 04:01:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33481 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812Ab0CAJBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 04:01:55 -0500
Date: Mon, 1 Mar 2010 10:01:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Dave Jones <davej@redhat.com>, Jean Delvare <khali@linux-fr.org>,
       Greg KH <greg@kroah.com>, "J. Bruce Fields" <bfields@fieldses.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Sage Weil <sage@newdream.net>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Al Viro <viro@ZenIV.linux.org.uk>, J??rn Engel <joern@logfs.org>
Subject: Re: linux-next: current pending merge fix patches
Message-ID: <20100301090130.GA13880@elte.hu>
References: <20100301160445.5e281f11.sfr@canb.auug.org.au>
 <20100301081021.GB8049@elte.hu>
 <20100301195532.d9e5ae64.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100301195532.d9e5ae64.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Ingo,
> 
> On Mon, 1 Mar 2010 09:10:21 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> >
> > > This could also be taken as a reminder to the respective maintiners that 
> > > they may want to do a merge of your tree before asking you to pull theirs.
> > 
> > I dont think that's generally correct for trivial conflicts: it's better if 
> > Linus does the merge of a tree that is based in some stable tree.
> 
> In general I agree.  I have singled out these conflict resolutions because 
> they involve either files not obvious from the conflicts (newly introduced 
> or chunks of code moved between files), or chunks of code that are 
> introduced in one tree but need to be modified after the otheris merged.  So 
> in that sense they are a heads up to Linus because they are only found after 
> you do the merge and then get a build failure (if you do the right builds).
> 
> So they can be resolved by Linus after he merges the second tree or by the 
> original maintainer of one of the trees merging/cherrypicking (part of) the 
> other tree or waiting for Linus to merge the other tree and then do a merge 
> with Linus' tree.

Conflict reminders are certainly useful - even for trivial commits.

My comments mostly related to the part of your suggestion that subsystem 
maintainers may merge in Linus's tree before they send their pull request to 
Linus - which i dont agree with in the general case, for the aforementioned 
reasons.

Thanks,

	Ingo
