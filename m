Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446Ab0AHC72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab0AHC72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 21:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400Ab0AHC71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 21:59:27 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:34611 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab0AHC70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 21:59:26 -0500
Date: Fri, 8 Jan 2010 13:59:24 +1100
From: Simon Horman <horms@verge.net.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, Michal Marek <mmarek@sues.cz>,
       Roland Dreier <rdreier@cisco.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch] Makefile: Unexport LANG
Message-ID: <20100108025924.GE2465@verge.net.au>
References: <20091224111300.GA31932@verge.net.au>
 <4B359166.3050106@redhat.com>
 <4B359BC0.3080808@zytor.com>
 <20091226112007.GB2818@verge.net.au>
 <20100108004117.GK2436@verge.net.au>
 <4B467FCB.2080101@zytor.com>
 <20100108024553.GA2465@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100108024553.GA2465@verge.net.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 01:45:56PM +1100, Simon Horman wrote:
> On Thu, Jan 07, 2010 at 04:43:55PM -0800, H. Peter Anvin wrote:
> > On 01/07/2010 04:41 PM, Simon Horman wrote:
> > > On Sat, Dec 26, 2009 at 10:20:07PM +1100, Simon Horman wrote:
> > >> On Fri, Dec 25, 2009 at 09:14:40PM -0800, H. Peter Anvin wrote:
> > >>> On 12/25/2009 08:30 PM, Masami Hiramatsu wrote:
> > >>>>>  
> > >>>>>  # Avoid funny character set dependencies
> > >>>>> +unexport LANG
> > >>>>>  unexport LC_ALL
> > >>>>>  LC_CTYPE=C
> > >>>>>  LC_COLLATE=C
> > >>>>
> > >>>
> > >>> At this point, it seems to me that we should just LC_ALL=C and be done
> > >>> with it (see other thread.)
> > >>
> > >> Sure, that would also work for the case that I'm seeing.
> > >>
> > >> I tested the following:
> > >>
> > >> # Avoid funny character set dependencies
> > >> LC_ALL=C
> > >> export LC_ALL
> > >>
> > >> Though personally I would advocate tweaking the locale as needed closer
> > >> to awk scripts and the like, rather than the high-level general change that
> > >> was made. Fall-out from a high-level change seems inevitable to me.
> > > 
> > > This seems to still be broken. Can we decide on a solution?
> > > 
> > 
> > I think it's up to Michal to pick the preferred solution.

Is it just me or is Michal's email bouncing of late?

