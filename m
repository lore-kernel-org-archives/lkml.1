Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbYGPExx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbYGPExx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 00:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbYGPExp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 00:53:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751427AbYGPExo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 00:53:44 -0400
Date: Tue, 15 Jul 2008 21:51:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, davem@davemloft.net, mingo@elte.hu,
       nhorman@tuxdriver.com, simon@fire.lp0.eu, linux-kernel@vger.kernel.org
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
 000000000000000e (reset_prng_context)
Message-Id: <20080715215153.16ba2594.akpm@linux-foundation.org>
In-Reply-To: <20080716043312.GA12765@gondor.apana.org.au>
References: <487BE071.80101@simon.arlott.org.uk>
	<20080715020428.GA27463@hmsendeavour.rdu.redhat.com>
	<20080715113304.GA30565@elte.hu>
	<20080715.134407.150543177.davem@davemloft.net>
	<20080715214929.GA18268@martell.zuzino.mipt.ru>
	<20080715151110.d7a17c89.akpm@linux-foundation.org>
	<20080716040701.GA12570@gondor.apana.org.au>
	<20080715212549.1c41c1d0.akpm@linux-foundation.org>
	<20080716043312.GA12765@gondor.apana.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2008 12:33:12 +0800 Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Tue, Jul 15, 2008 at 09:25:49PM -0700, Andrew Morton wrote:
> > On Wed, 16 Jul 2008 12:07:01 +0800 Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > 
> > > On Tue, Jul 15, 2008 at 03:11:10PM -0700, Andrew Morton wrote:
> > > >
> > > > Except that such a high density of coding-style errors is an indication
> > > > that the code was not closely and critically reviewed by an experienced
> > > > kernel developer.
> > > > 
> > > > > Every damn single warning in this case is about whitespace or 80 column limit.
> > > > > 
> > > > > Every damn single one!
> > > 
> > > Indeed, I apologise for reviewing the code on a monitor that is wider
> > > than yours.  If only we could make sure that all Linux developers
> > > used smaller monitors then the code quality would surely improve!
> > > 
> > 
> > Remaining within 80 cols is a big deal indeed for those who choose to
> > use, or who are forced to use 80-col displays.  Try resizing to 70 cols
> > for a while, see how you get on.
> 
> Sure, I totally understand the 80-column requirement and support
> it too.
> 
> However, I fail to see how one could draw the conclusion that a
> piece of code that breaks the 80-column rule has not been closely
> or critically reviewed.

I said "indication".  I came to no conclusion.

And I agree with me.  I fail to see how someone who is familiar with
kernel code and who is reviewing a submission could let something like

	for (i=DEFAULT_BLK_SZ-1;i>0;i--) {

pass without comment.

> Excuse me for not focusing on white-space or code-width issues
> when reviewing code.

Please do so?  You hopefully only need to do it once per submitter
and we now have a tool which people can use to aid the process.  It's
hardly a large burden.

btw, I've searched my linux-kernel archives and netdev archives and the
linux-crypto web archives and can find no sign of any submission or
discussion of this patch.  Am I looking in the wrong places?
