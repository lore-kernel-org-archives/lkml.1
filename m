Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbZJVGZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbZJVGZG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 02:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbZJVGZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 02:25:05 -0400
Received: from ernst.netinsight.se ([194.16.221.21]:1297 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752998AbZJVGZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 02:25:04 -0400
Date: Thu, 22 Oct 2009 08:25:00 +0200
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v11 4/5] core: Add kernel message dumper to call on
 oopses and panics
Message-ID: <20091022082500.602f9a7d@marrow.netinsight.se>
In-Reply-To: <alpine.LFD.2.00.0910220832580.9771@eeepc.linux-foundation.org>
References: <20091015093133.GF10546@elte.hu>
	<20091015161052.0752208e@marrow.netinsight.se>
	<20091015154640.GA11408@elte.hu>
	<20091016094601.4e2c2d3e@marrow.netinsight.se>
	<20091016080935.GA3895@elte.hu>
	<1255681467.32489.360.camel@localhost>
	<20091016112556.6902b2dc@marrow.netinsight.se>
	<20091016101045.GA3263@elte.hu>
	<20091016140918.3981cfa2@marrow.netinsight.se>
	<1255952922.32489.505.camel@localhost>
	<20091019125017.GA9030@elte.hu>
	<alpine.LFD.2.00.0910220832580.9771@eeepc.linux-foundation.org>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Oct 2009 08:33:11 +0900 (JST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > > I wonder, via which tree this should go in. We are going to have mtdoops
> > > depend on this. Should we go one of these ways:
> > > 
> > >    * this patch goes to one of Ingo's tip trees, so we can pull it and
> > >      work on top.
> > >    * we have Ingo's / Linus' acks, and this goes via the MTD tree.
> > > ?
> > 
> > Either way is good to me. Linus, do you have any preferences?
> 
> Either works for me.

I would put it all through Artems MTD tree then so that we keep the new
API and the user of it close together then.

Thanks to everyone for the reviewing and suggestions!

// Simon
