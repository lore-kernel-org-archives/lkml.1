Return-Path: <linux-kernel-owner+w=401wt.eu-S934251AbXKPCmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934251AbXKPCmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 21:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755695AbXKPCmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 21:42:24 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54334
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755437AbXKPCmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 21:42:24 -0500
Date: Thu, 15 Nov 2007 18:42:22 -0800 (PST)
Message-Id: <20071115.184222.240089630.davem@davemloft.net>
To: greg@kroah.com
Cc: herbert@gondor.apana.org.au, bunk@kernel.org, tytso@mit.edu,
       zwane@arm.linux.org.uk, torvalds@linux-foundation.org, gregkh@suse.de,
       jmforbes@linuxtx.org, linux-kernel@vger.kernel.org,
       reviews@ml.cw.f00f.org, cavokz@gmail.com, rdunlap@xenotime.net,
       mkrufky@linuxtv.org, cebbert@redhat.com, davej@redhat.com,
       akpm@linux-foundation.org, chuckw@quantumlinux.com, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 06/23] Fix SKB_WITH_OVERHEAD calculations.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071116003102.GA6855@kroah.com>
References: <20071114.230039.114721276.davem@davemloft.net>
	<20071115073122.GA24246@gondor.apana.org.au>
	<20071116003102.GA6855@kroah.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <greg@kroah.com>
Date: Thu, 15 Nov 2007 16:31:02 -0800

> On Thu, Nov 15, 2007 at 03:31:22PM +0800, Herbert Xu wrote:
> > On Wed, Nov 14, 2007 at 11:00:39PM -0800, David Miller wrote:
> > >
> > > I was just about to mention this and what I think we should do
> > > instead is keep the SKB_WITH_OVERHEAD calculation fix in there
> > > (it fixes a serious bug which users are hitting) and add the
> > > fix for the second bug fix this round as well.
> > > 
> > > Therefore, Greg please keep the patch add the following one as it will
> > > address all of the issues.
> > 
> > I agree.  If the stable team could make an exception for this
> > it would be great.
> 
> No problem, I've added this patch to the series right after the above
> mentioned one and it will come out in the next release.

Thanks a lot Greg.
