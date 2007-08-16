Return-Path: <linux-kernel-owner+w=401wt.eu-S937752AbXHPCSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937752AbXHPCSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 22:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762708AbXHPCSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 22:18:33 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54649 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760515AbXHPCSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 22:18:31 -0400
Date: Wed, 15 Aug 2007 19:18:30 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: Satyam Sharma <satyam@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Paul Mackerras <paulus@samba.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Chris Snook <csnook@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       cfriesen@nortel.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com, segher@kernel.crashing.org
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all
 architectures
In-Reply-To: <20070816020851.GA30809@gondor.apana.org.au>
Message-ID: <Pine.LNX.4.64.0708151917210.11736@schroedinger.engr.sgi.com>
References: <alpine.LFD.0.999.0708151713080.16414@enigma.security.iitk.ac.in>
 <18115.35524.56393.347841@cargo.ozlabs.ibm.com>
 <Pine.LNX.4.64.0708151725130.10497@schroedinger.engr.sgi.com>
 <20070816003948.GY9645@linux.vnet.ibm.com> <Pine.LNX.4.64.0708151740570.10497@schroedinger.engr.sgi.com>
 <20070816005348.GA9645@linux.vnet.ibm.com> <Pine.LNX.4.64.0708151757400.11196@schroedinger.engr.sgi.com>
 <20070816011414.GC9645@linux.vnet.ibm.com> <Pine.LNX.4.64.0708151839140.11520@schroedinger.engr.sgi.com>
 <alpine.LFD.0.999.0708160730590.24380@enigma.security.iitk.ac.in>
 <20070816020851.GA30809@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Aug 2007, Herbert Xu wrote:

> > Do we have a consensus here? (hoping against hope, probably :-)
> 
> I can certainly agree with this.

I agree too.

> But I have to say that I still don't know of a single place
> where one would actually use the volatile variant.

I suspect that what you say is true after we have looked at all callers.


