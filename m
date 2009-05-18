Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbZERIla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbZERIla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 04:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbZERIlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 04:41:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49486 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbZERIlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 04:41:16 -0400
Date: Mon, 18 May 2009 10:40:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jeremy@goop.org, x86@kernel.org, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, gregkh@suse.de, okir@suse.de
Subject: Re: Where do we stand with the Xen patches?
Message-ID: <20090518084052.GD10687@elte.hu>
References: <4A0C770E.2030305@goop.org> <20090518103520J.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090518103520J.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Thu, 14 May 2009 12:54:54 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > Hi Ingo,
> > 
> > Over the last week or so, I've set out pull requests for the following 
> > branches in git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git :
> > 
> > for-ingo/xen/dom0/core
> > 
> >     You made two comments about the first post of this set:
> > 
> >        1. The // comments in the mtrr code.  Now fixed.
> >        2. A query about when Xen can support PAT.  In progress; when its
> >           done, we can remove the unconditional PAT disable.
> > 
> > for-ingo/xen/dom0/pci
> > for-ingo/xen/dom0/swiotlb
> > 
> >     Updated with Joerg Roedel, FUJITA Tomonori and Matthew Wilcox's
> >     comments,  Acked-by and Reviewed-bys as appropriate.
> 
> The original code added dom0-specific dma mapping stuff in the 
> generic place, which is completely wrong. I asked you to move the 
> hacky stuff to Xen-specific code and ack'ed the patchset.
> 
> But as I said again and again, the dom0 changes to the generic dma 
> mapipng code is really ugly and I don't like them at all. I didn't 
> ack'ed such changes.

How should it be solved instead? Can you see a clean way to achieve 
it? (maybe you already explained it in past threads - if yes then 
have you got subject lines or URIs to that?)

Thanks,

	Ingo
