Return-Path: <linux-kernel-owner+w=401wt.eu-S1760740AbXE1BPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760740AbXE1BPe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 21:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756072AbXE1BP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 21:15:27 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43743 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753087AbXE1BP0 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 21:15:26 -0400
Date: Mon, 28 May 2007 11:15:02 +1000
From: David Chinner <dgc@sgi.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, xfs-masters@oss.sgi.com,
       David Chinner <dgc@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       tes@sgi.com
Subject: Re: 2.6.22-rc2: known regressions with patches
Message-ID: <20070528011502.GW85884050@sgi.com>
References: <46559B62.5040903@googlemail.com> <4658D26C.9010803@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4658D26C.9010803@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2007 at 01:35:56AM +0100, Jeremy Fitzhardinge wrote:
> Michal Piotrowski wrote:
> > File systems
> >
> > Subject    : 2.6.21-git10/11: files getting truncated on xfs
> > References : http://lkml.org/lkml/2007/5/9/410
> > Submitter  : Jeremy Fitzhardinge <jeremy@goop.org>
> > Handled-By : David Chinner <dgc@sgi.com>
> > Patch      : http://lkml.org/lkml/2007/5/12/93
> > Status     : patch available
> >   
> 
> I'm satisfied the patch fixes the problem for me.  Can we have some
> movement to get it into at least -mm?  This is a real, serious
> data-corrupting bug.  Ideally we should get it into -rc asap.

Patience, please. We like to have some QA coverage on a changes that
affect the writeback path in such a subtle manner before saying it
is good to go. Just releasing the fix into the main tree would be
irresponsible as there is the real possibility of the fix causing
other subtle corruption problems.

The fact the fix Works For You doesn't mean it works for everyone so
we need to take the time to make sure the fix is correct rather than
doing a half-arsed job of it and potentially leaving a landmine that
explodes on the wider community after release.

That being said, the fix doesn't appear to have any landmines in
it so we'll be pushing it to Linus RSN...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
