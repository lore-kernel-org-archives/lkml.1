Return-Path: <linux-kernel-owner+w=401wt.eu-S937233AbXHPAuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937233AbXHPAuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 20:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755318AbXHPAt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 20:49:56 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36182 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764616AbXHPAty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 20:49:54 -0400
Date: Wed, 15 Aug 2007 17:49:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Herbert Xu <herbert.xu@redhat.com>
Cc: David Howells <dhowells@redhat.com>, Satyam Sharma <satyam@infradead.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Christoph Lameter <clameter@sgi.com>, Chris Snook <csnook@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       cfriesen@nortel.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com, segher@kernel.crashing.org
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Message-ID: <20070816004950.GZ9645@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <46C2FADB.7020407@s5r6.in-berlin.de> <alpine.LFD.0.999.0708151906330.16414@enigma.security.iitk.ac.in> <20070815142516.GB9645@linux.vnet.ibm.com> <4413.1187201997@redhat.com> <20070815184520.GG9645@linux.vnet.ibm.com> <20070815234146.GB28775@gondor.apana.org.au> <20070815235335.GU9645@linux.vnet.ibm.com> <20070816001248.GA29214@gondor.apana.org.au> <20070816002310.GW9645@linux.vnet.ibm.com> <20070816003023.GA29447@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070816003023.GA29447@gondor.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 08:30:23AM +0800, Herbert Xu wrote:
> On Wed, Aug 15, 2007 at 05:23:10PM -0700, Paul E. McKenney wrote:
> > On Thu, Aug 16, 2007 at 08:12:48AM +0800, Herbert Xu wrote:
> > > On Wed, Aug 15, 2007 at 04:53:35PM -0700, Paul E. McKenney wrote:
> > > >
> > > > > > Communicating between process context and interrupt/NMI handlers using
> > > > > > per-CPU variables.
> > > > > 
> > > > > Remeber we're talking about atomic_read/atomic_set.  Please
> > > > > cite the actual file/function name you have in mind.
> > > > 
> > > > Yep, we are indeed talking about atomic_read()/atomic_set().
> > > > 
> > > > We have been through this issue already in this thread.
> > > 
> > > Sorry, but I must've missed it.  Could you cite the file or
> > > function for my benefit?
> > 
> > I might summarize the thread if there is interest, but I am not able to
> > do so right this minute.
> 
> Thanks.  But I don't need a summary of the thread, I'm asking
> for an extant code snippet in our kernel that benefits from
> the volatile change and is not part of a busy-wait.

Sorry, can't help you there.  I really do believe that the information
you need (as opposed to the specific item you are asking for) really
has been put forth in this thread.

						Thanx, Paul
