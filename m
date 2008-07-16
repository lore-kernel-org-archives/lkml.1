Return-Path: <linux-kernel-owner+w=401wt.eu-S1756274AbYGPE1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274AbYGPE1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 00:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbYGPE1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 00:27:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751402AbYGPE1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 00:27:14 -0400
Date: Tue, 15 Jul 2008 21:25:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, davem@davemloft.net, mingo@elte.hu,
       nhorman@tuxdriver.com, simon@fire.lp0.eu, linux-kernel@vger.kernel.org
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
 000000000000000e (reset_prng_context)
Message-Id: <20080715212549.1c41c1d0.akpm@linux-foundation.org>
In-Reply-To: <20080716040701.GA12570@gondor.apana.org.au>
References: <487BE071.80101@simon.arlott.org.uk>
	<20080715020428.GA27463@hmsendeavour.rdu.redhat.com>
	<20080715113304.GA30565@elte.hu>
	<20080715.134407.150543177.davem@davemloft.net>
	<20080715214929.GA18268@martell.zuzino.mipt.ru>
	<20080715151110.d7a17c89.akpm@linux-foundation.org>
	<20080716040701.GA12570@gondor.apana.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2008 12:07:01 +0800 Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Tue, Jul 15, 2008 at 03:11:10PM -0700, Andrew Morton wrote:
> >
> > Except that such a high density of coding-style errors is an indication
> > that the code was not closely and critically reviewed by an experienced
> > kernel developer.
> > 
> > > Every damn single warning in this case is about whitespace or 80 column limit.
> > > 
> > > Every damn single one!
> 
> Indeed, I apologise for reviewing the code on a monitor that is wider
> than yours.  If only we could make sure that all Linux developers
> used smaller monitors then the code quality would surely improve!
> 

Remaining within 80 cols is a big deal indeed for those who choose to
use, or who are forced to use 80-col displays.  Try resizing to 70 cols
for a while, see how you get on.

And that's the point: the utility to you (and me) of using >80 cols is
much less than the loss of utility to those who are stuck with 80 cols.
That's why we have a standard.

me, I'd be perfectly happy with upping that standard to 96 cols but I
seem unable to get anyone else to chew on that bait so shrug.  But for the
above reasons we _do_ need to have a standard and to stick to it.

(I mean it - try the 70 col experiment!)
