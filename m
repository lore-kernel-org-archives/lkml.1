Return-Path: <linux-kernel-owner+w=401wt.eu-S934401AbXKPAhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934401AbXKPAhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 19:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763638AbXKPAhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 19:37:23 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43537 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756976AbXKPAhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 19:37:23 -0500
Date: Thu, 15 Nov 2007 16:31:02 -0800
From: Greg KH <greg@kroah.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Miller <davem@davemloft.net>, bunk@kernel.org, tytso@mit.edu,
       zwane@arm.linux.org.uk, torvalds@linux-foundation.org, gregkh@suse.de,
       jmforbes@linuxtx.org, linux-kernel@vger.kernel.org,
       reviews@ml.cw.f00f.org, cavokz@gmail.com, rdunlap@xenotime.net,
       mkrufky@linuxtv.org, cebbert@redhat.com, davej@redhat.com,
       akpm@linux-foundation.org, chuckw@quantumlinux.com, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 06/23] Fix SKB_WITH_OVERHEAD calculations.
Message-ID: <20071116003102.GA6855@kroah.com>
References: <20071115055238.692814352@mini.kroah.org> <20071115062022.GG8282@kroah.com> <20071115062939.GA23579@gondor.apana.org.au> <20071114.230039.114721276.davem@davemloft.net> <20071115073122.GA24246@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071115073122.GA24246@gondor.apana.org.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 03:31:22PM +0800, Herbert Xu wrote:
> On Wed, Nov 14, 2007 at 11:00:39PM -0800, David Miller wrote:
> >
> > I was just about to mention this and what I think we should do
> > instead is keep the SKB_WITH_OVERHEAD calculation fix in there
> > (it fixes a serious bug which users are hitting) and add the
> > fix for the second bug fix this round as well.
> > 
> > Therefore, Greg please keep the patch add the following one as it will
> > address all of the issues.
> 
> I agree.  If the stable team could make an exception for this
> it would be great.

No problem, I've added this patch to the series right after the above
mentioned one and it will come out in the next release.

thanks for the review,

greg k-h
