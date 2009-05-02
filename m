Return-Path: <linux-kernel-owner+w=401wt.eu-S1753637AbZEBCN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbZEBCN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 22:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbZEBCNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 22:13:18 -0400
Received: from THUNK.ORG ([69.25.196.29]:56000 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbZEBCNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 22:13:17 -0400
Date: Fri, 1 May 2009 22:12:58 -0400
From: Theodore Tso <tytso@mit.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Steve French <smfrench@gmail.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       Andrew Tridgell <tridge@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
Message-ID: <20090502021258.GJ7681@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>,
	Steve French <smfrench@gmail.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Michael Tokarev <mjt@tls.msk.ru>,
	Paul McKenney <paulmck@linux.vnet.ibm.com>,
	Andrew Tridgell <tridge@samba.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <524f69650905011318m34e0027dt57877d225b3fe2da@mail.gmail.com> <20090501210109.GA3079@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501210109.GA3079@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 05:01:09PM -0400, Christoph Hellwig wrote:
> Steve, can you please stop the bullshitting?
> 
> From the complete lack of technical arguments it's pretty obvious that
> this seems to be some FUD fallout from the MS vs TomTom patent lawsuite.
> 
> I'm not a lawyer so I don't know how much of a threat it is.  But either
> the case gets shot down by showing prior art and everything is fine, or
> we indeed are in deep trouble and should remove it completely.  Given
> the Cc list on here IBM seems to have some legal opinion on it, so can
> we please see it and discuss what we want to with all cards on the
> table?

It's really not that simple.  For some of the complexities involved,
please see:

http://arstechnica.com/open-source/news/2009/04/open-invention-network-seeks-prior-art-to-burn-fat-patents.ars

http://arstechnica.com/open-source/news/2009/04/linux-foundation-says-its-time-to-ditch-microsofts-fat.ars

I personally believe that the patents are bullshit, but at the same
time, I also believe that the USPTO is underfunded, has incompetent
patent examiners (if they were competent engineers they could be
making 2 or 3 times as much money and have much better working
conditions), and they are very loath to admit that they make mistakes,
whch is just human nature, I suppose --- and also, that in our
society, you get the best justice money can buy.

Even if the patents are bullshit, some companies, especially those
that might not have the money to engage in long, extended, drawn-out
patent battles that could easily cost $10 million minimum, might
decide that it's better to evade the issue than to fight the good
fight.  If you're a small company, and you can't afford the legal
battle, or worse yet, be able to survive drop in sales caused by the
FUD generated during the lawsuit about whether or not you'll be around
to support your customers in the long-term, you make make difference
choices compared to some other larger, more secure company.

I have no trouble walking in Chinatown near the "Combat Zone" in
Boston at night; someone who is half my size and female and who has
had no martial arts training, however, might decide differently.  In
neither case is the mugger justified in doing what they are doing, but
we live in an imperfect world, where pirates can hijack ships near
Somalia even though that's also Wrong.

So I don't believe removing the code is the right thing to do.  I do
believe that giving people who build and use the Linux kernel choice
is a good thing; consider that digital cameras manufactures have
adhered to a 8.3 filenames, which is encoded in the DCIM standard, for
15+ years --- and I don't believe that's an accident.  What might lead
one company to settle and another one to fight and another to decide
to evade the issue, may depend on many things, and may have very
little have to do with Truth or Ethics or Morality.  Welcome to the
law and business as practiced in our civilized society.

(But hey, at least we don't torture people!  :-)

    		    	      	     	       - Ted

P.S.  Everything in this e-mail is my own opinion, and does not
necessarily represent the positions, strategies, or opinions of IBM or
the Linux Foundation.
