Return-Path: <linux-kernel-owner+w=401wt.eu-S1751725AbZJUXed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbZJUXed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 19:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750896AbZJUXec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 19:34:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750749AbZJUXeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 19:34:31 -0400
Date: Thu, 22 Oct 2009 08:33:11 +0900 (JST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Artem Bityutskiy <dedekind1@gmail.com>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v11 4/5] core: Add kernel message dumper to call on oopses
 and panics
In-Reply-To: <20091019125017.GA9030@elte.hu>
Message-ID: <alpine.LFD.2.00.0910220832580.9771@eeepc.linux-foundation.org>
References: <20091015093133.GF10546@elte.hu> <20091015161052.0752208e@marrow.netinsight.se> <20091015154640.GA11408@elte.hu> <20091016094601.4e2c2d3e@marrow.netinsight.se> <20091016080935.GA3895@elte.hu> <1255681467.32489.360.camel@localhost>
 <20091016112556.6902b2dc@marrow.netinsight.se> <20091016101045.GA3263@elte.hu> <20091016140918.3981cfa2@marrow.netinsight.se> <1255952922.32489.505.camel@localhost> <20091019125017.GA9030@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 19 Oct 2009, Ingo Molnar wrote:
> > 
> > I wonder, via which tree this should go in. We are going to have mtdoops
> > depend on this. Should we go one of these ways:
> > 
> >    * this patch goes to one of Ingo's tip trees, so we can pull it and
> >      work on top.
> >    * we have Ingo's / Linus' acks, and this goes via the MTD tree.
> > ?
> 
> Either way is good to me. Linus, do you have any preferences?

Either works for me.

		Linus
