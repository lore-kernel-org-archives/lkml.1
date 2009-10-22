Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbZJVGg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbZJVGg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 02:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbZJVGg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 02:36:57 -0400
Received: from smtp.nokia.com ([192.100.122.230]:22506 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbZJVGg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 02:36:56 -0400
Subject: Re: [PATCH v11 4/5] core: Add kernel message dumper to call on
 oopses and panics
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Simon Kagstrom <simon.kagstrom@netinsight.net>,
       David Woodhouse <dwmw2@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-mtd <linux-mtd@lists.infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20091022082500.602f9a7d@marrow.netinsight.se>
References: <20091015093133.GF10546@elte.hu>
	 <20091015161052.0752208e@marrow.netinsight.se>
	 <20091015154640.GA11408@elte.hu>
	 <20091016094601.4e2c2d3e@marrow.netinsight.se>
	 <20091016080935.GA3895@elte.hu> <1255681467.32489.360.camel@localhost>
	 <20091016112556.6902b2dc@marrow.netinsight.se>
	 <20091016101045.GA3263@elte.hu>
	 <20091016140918.3981cfa2@marrow.netinsight.se>
	 <1255952922.32489.505.camel@localhost> <20091019125017.GA9030@elte.hu>
	 <alpine.LFD.2.00.0910220832580.9771@eeepc.linux-foundation.org>
	 <20091022082500.602f9a7d@marrow.netinsight.se>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Oct 2009 09:36:08 +0300
Message-Id: <1256193368.29856.466.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 22 Oct 2009 06:36:14.0991 (UTC) FILETIME=[F41979F0:01CA52E1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-22 at 08:25 +0200, Simon Kagstrom wrote:
> On Thu, 22 Oct 2009 08:33:11 +0900 (JST)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > > > I wonder, via which tree this should go in. We are going to have mtdoops
> > > > depend on this. Should we go one of these ways:
> > > > 
> > > >    * this patch goes to one of Ingo's tip trees, so we can pull it and
> > > >      work on top.
> > > >    * we have Ingo's / Linus' acks, and this goes via the MTD tree.
> > > > ?
> > > 
> > > Either way is good to me. Linus, do you have any preferences?
> > 
> > Either works for me.
> 
> I would put it all through Artems MTD tree then so that we keep the new
> API and the user of it close together then.
> 
> Thanks to everyone for the reviewing and suggestions!
> 

It's dwmw2's tree actually. I just act as his secretary :-)

David, could you push this patch to your tree? Ingo's and Linus' acks
are there, AFAIU.

Simon, I'll look at your other mtdoops patches as well a bit later.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

