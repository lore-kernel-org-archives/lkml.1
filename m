Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbYB1B3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbYB1B3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 20:29:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYB1B2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 20:28:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbYB1B2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 20:28:50 -0500
Date: Wed, 27 Feb 2008 22:27:30 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       dada1@cosmosbay.com, herbert@gondor.apana.org.au,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: include/linux/pcounter.h
Message-ID: <20080228012730.GN4725@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
	akpm@linux-foundation.org, dada1@cosmosbay.com,
	herbert@gondor.apana.org.au, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080216112618.ec450f9b.akpm@linux-foundation.org> <20080216.215401.20463603.davem@davemloft.net> <20080226092454.GA10987@elte.hu> <20080226.133531.69481052.davem@davemloft.net> <20080227073650.GC4638@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227073650.GC4638@elte.hu>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Feb 27, 2008 at 08:36:50AM +0100, Ingo Molnar escreveu:
> 
> * David Miller <davem@davemloft.net> wrote:
> 
> > > but the main and fundamental question still remains unanswered (more 
> > > than 3 weeks after Andrew asked that question): why was this piece 
> > > of general infrastructure merged via net.git and not submitted to 
> > > lkml ever? The code touching -mm does _not_ count as "review".
> > 
> > I already stated this was a mistake and it won't happen again in the 
> > future.
> 
> sorry - that bit of the thread didnt seem to make it to lkml. I just saw 
> this incomplete discussion with a denial and with no resolution.
> 
> And you did the right thing anyway by thinking in terms of a generic 
> piece of infrastructure instead of hiding it away into say 
> include/net/pcounter.h (which nobody could have objected against).
> 
> I sometimes think that the forced isolation of subsystems (rather 
> strongly enforced both by -mm and by linux-next) and their hiding away 
> on non-lkml lists will eventually hurt the core kernel because less and 
> less people will be willing to go the trouble of doing proper 
> cross-subsystem development. That results in duplicated or specialistic 
> infrastructure, increased code size and longer term, ultimately less 
> performance. (by the time we notice _that_ it will probably be too late 
> to do anything about it)

This more friendly wording makes me feel actually happy to get from my
hiding place and tell that I actually saw the percpu counters code, just
after I made Eric's code generic as I thought it should have been from
the start, I found out about what was already in lib/.

I just got lazy to do what at the time looked the right thing
to do: to read thru the existing lib/ code and use it where pcounter was
being used. But at least it got exposed 8-)

Anyway, progress was made, I do not feel too bad about it even now.

- Arnaldo
