Return-Path: <linux-kernel-owner+w=401wt.eu-S1759396AbYBZHeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396AbYBZHeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 02:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbYBZHeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 02:34:15 -0500
Received: from ping.pong.ch ([212.103.71.101]:38245 "EHLO ping.pong.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550AbYBZHeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 02:34:14 -0500
Date: Tue, 26 Feb 2008 08:34:07 +0100
From: Gaudenz Steinlin <gaudenz@soziologie.ch>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Christoph Hellwig <hch@lst.de>, xfs-masters@oss.sgi.com,
       Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com,
       johannes@sipsolutions.net,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [xfs-masters] Re: filesystem corruption on xfs after
	2.6.25-rc1 (bisected, powerpc related?)
Message-ID: <20080226073407.GA5762@soziologie.ch>
References: <20080225112310.GA5516@soziologie.ch> <200802260052.57875.rjw@sisk.pl> <20080225235703.GA17530@lst.de> <200802260113.57875.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802260113.57875.rjw@sisk.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 01:13:56AM +0100, Rafael J. Wysocki wrote:
> On Tuesday, 26 of February 2008, Christoph Hellwig wrote:
> > On Tue, Feb 26, 2008 at 12:52:56AM +0100, Rafael J. Wysocki wrote:
> > > > I'm not suggesting a partial revert; I just wonder which part of the
> > > > change is causing the problem, as part of the debugging process.
> > > 
> > > Understood.
> > > 
> > > My point is, if that's not practical (whatever the reason), I'd consider
> > > reverting all of the commits in question.
> > 
> > If you could revert all of them and verify it makes the problem go away
> > that would be a very good start already.
> 
> The original reporter (CC added) said exactly that, if I understood him
> correctly:
> 
> http://lkml.org/lkml/2008/2/25/123

Sorry if I was not clear. The problematic commit after bisecting is
a69b176df246d59626e6a9c640b44c0921fa4566. Reverting this commit and
commit edd319dc527733e61eec5bdc9ce20c94634b6482 fixes the problem. So
all other commits in the XFS merge for 2.6.25 seem to be OK. I had to
revert the second commit only to avoid a merge conflict.

And I forget to mention on my first post: Please CC me on all replies.
I'm not subscribed to the lists.

Gaudenz

-- 
Ever tried. Ever failed. No matter.
Try again. Fail again. Fail better.
~ Samuel Beckett ~
