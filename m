Return-Path: <linux-kernel-owner+w=401wt.eu-S1758078AbYCZLDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbYCZLDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 07:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756336AbYCZLDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 07:03:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53790 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756716AbYCZLDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 07:03:08 -0400
Date: Wed, 26 Mar 2008 12:02:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: J?rn Engel <joern@logfs.org>, David Miller <davem@davemloft.net>,
       jirislaby@gmail.com, joe@perches.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [patch] bkl2mtd: cleanup
Message-ID: <20080326110247.GE17176@elte.hu>
References: <20080323.051929.267232495.davem@davemloft.net> <20080325104841.GA24211@elte.hu> <20080325111129.GB11359@logfs.org> <20080325122413.GA8729@elte.hu> <20080325131258.GC11359@logfs.org> <20080325133810.GA10044@elte.hu> <20080325134556.GA10424@elte.hu> <20080325160734.GA14583@logfs.org> <20080326101452.GA17176@elte.hu> <20080326104821.GS10722@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326104821.GS10722@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
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


* Al Viro <viro@ZenIV.linux.org.uk> wrote:

> > -		if (ret) {
> > +		if (ret)
> >  			parse_err("illegal erase size");
> > -		}
> >  	}
> 
> BTW, I certainly wouldn't inflict that on patches; at some point in 
> series the body of if may shrink to one line only to get longer in the 
> next patch.  Removing and restoring {} would only add noise.

agreed, we dont enforce it strictly - it is the end result that must be 
clean.

[ OTOH, when i create a patch series i personally always try to make 
  each patch clean, because one never knows when a later patch gets 
  delayed or dropped altogether. ]

	Ingo
