Return-Path: <linux-kernel-owner+w=401wt.eu-S935644AbXHOSpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935644AbXHOSpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 14:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765319AbXHOSp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 14:45:29 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51779 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762777AbXHOSpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 14:45:24 -0400
Date: Wed, 15 Aug 2007 11:45:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Satyam Sharma <satyam@infradead.org>,
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
Message-ID: <20070815184520.GG9645@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070815153335.GA23593@gondor.apana.org.au> <20070809131423.GA9927@shell.boston.redhat.com> <Pine.LNX.4.64.0708141529310.32693@schroedinger.engr.sgi.com> <alpine.LFD.0.999.0708150417240.6482@enigma.security.iitk.ac.in> <46C2D6F3.3070707@s5r6.in-berlin.de> <alpine.LFD.0.999.0708151713080.16414@enigma.security.iitk.ac.in> <46C2FADB.7020407@s5r6.in-berlin.de> <alpine.LFD.0.999.0708151906330.16414@enigma.security.iitk.ac.in> <20070815142516.GB9645@linux.vnet.ibm.com> <4413.1187201997@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4413.1187201997@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 07:19:57PM +0100, David Howells wrote:
> Herbert Xu <herbert@gondor.apana.org.au> wrote:
> 
> > Let's turn this around.  Can you give a single example where
> > the volatile semantics is needed in a legitimate way?
> 
> Accessing H/W registers?  But apart from that...

Communicating between process context and interrupt/NMI handlers using
per-CPU variables.

							Thanx, Paul
