Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbYABV50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbYABV50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 16:57:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbYABV5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 16:57:15 -0500
Received: from mail.fieldses.org ([66.93.2.214]:49277 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333AbYABV5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 16:57:14 -0500
Date: Wed, 2 Jan 2008 16:57:06 -0500
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Neil Brown <neilb@suse.de>, netdev@vger.kernel.org,
       Tom Tucker <tom@opengridcomputing.com>
Subject: Re: 2.6.24-rc6-mm1
Message-ID: <20080102215706.GB6480@fieldses.org>
References: <64bb37e0712230827m7d368e2l3174f3b4396d09c1@mail.gmail.com> <64bb37e0712281453y4aac82b7h7acc8ec314ca6e3e@mail.gmail.com> <20071228150746.42b3bbc0.akpm@linux-foundation.org> <64bb37e0712290851r6d41768dk270e47884713a3de@mail.gmail.com> <20071230013021.GA13603@gondor.apana.org.au> <64bb37e0712291934o77a3d365h56c9c31ac8437469@mail.gmail.com> <64bb37e0712311215x519b10e9kd51eb745b3b7290a@mail.gmail.com> <20080101120406.GA27209@gondor.apana.org.au> <64bb37e0801021029u1735bb9eta53906b123abf577@mail.gmail.com> <20080102215154.GA13911@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080102215154.GA13911@gondor.apana.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2008 at 08:51:54AM +1100, Herbert Xu wrote:
> On Wed, Jan 02, 2008 at 07:29:59PM +0100, Torsten Kaiser wrote:
> >
> > Vanilla 2.6.24-rc6 seems stable. I did not see any crash or warnings.
> 
> OK that's great.  The next step would be to try excluding specific git
> trees from mm to see if they make a difference.
> 
> The two specific trees of interest would be git-nfsd and git-net.

Also, if it's git-nfsd, it'd be useful to test with the current git-nfsd
from the for-mm branch at:

	git://linux-nfs.org/~bfields/linus.git for-mm

and then any bisection results (even partial) from that tree would help
immensely....

--b.
