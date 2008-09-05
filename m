Return-Path: <linux-kernel-owner+w=401wt.eu-S1752466AbYIEJkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbYIEJkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 05:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbYIEJkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 05:40:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35904 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbYIEJj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 05:39:59 -0400
Date: Fri, 5 Sep 2008 11:43:16 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Bernd Schubert <bs@q-leap.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       jbeulich@novell.com
Subject: Re: frame unwinder patches
Message-ID: <20080905094316.GS18288@one.firstfloor.org>
References: <g9p3du$n95$1@ger.gmane.org> <87tzcvvi4p.fsf@basil.nowhere.org> <200809051124.17194.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809051124.17194.bs@q-leap.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2008 at 11:24:16AM +0200, Bernd Schubert wrote:
> On Thursday 04 September 2008 21:13:58 Andi Kleen wrote:
> > Bernd Schubert <bs@q-leap.de> writes:
> > > Hello,
> > >
> > > up to 2.6.22 the -mm series had these nice frame unwinder patches,
> > > which gave beautiful stack traces. Unfortunately these frame unwinder
> > > patches seem to have been dropped :(
> > >
> > > Anyone still maintaining updated patches?
> >
> > The SUSE kernel rpm should have an uptodate set
> >
> > (ftp.suse.com/pub/projects/kernel/HEAD )
> >
> 
> Thanks Andi, found it! If someone else needs it, the correct path is 
> ftp://ftp.suse.com/pub/projects/kernel/kotd/HEAD. 

Thanks for the correction.

> > I agree that they were much better than the current unwinder,
> > also they didn't require slowing down the kernel with
> > frame pointers.
> 
> What it the reason this patch isn't mainline? It provides better traces, 
> doesn't slow down the kernel (which is important in our HPC envirement), so 
> what is the disadvantage?

The initial version that was merged had a few teething problems because
it ran into tool chain bugs (which were quickly resolved). Unfortunately 
it lead to a few people developing irrational fears of dwarf2 in the 
process and it was reverted, annoying the original contributor.
Right now someone would just need to retry the submission I guess.

-Andi

-- 
ak@linux.intel.com
