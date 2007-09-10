Return-Path: <linux-kernel-owner+w=401wt.eu-S1760216AbXIJTAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760216AbXIJTAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759690AbXIJS7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 14:59:49 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43889 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759452AbXIJS7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 14:59:46 -0400
Date: Mon, 10 Sep 2007 11:59:35 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Denys Vlasenko <vda.linux@googlemail.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Nick Piggin <piggin@cyberone.com.au>,
       Satyam Sharma <satyam@infradead.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Paul Mackerras <paulus@samba.org>, Chris Snook <csnook@redhat.com>,
       Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       heiko.carstens@de.ibm.com, David Miller <davem@davemloft.net>,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       wjiang@resilience.com, cfriesen@nortel.com, zlynx@acm.org,
       rpjday@mindspring.com, jesper.juhl@gmail.com,
       segher@kernel.crashing.org
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all
 architectures
In-Reply-To: <alpine.LFD.0.999.0709100807260.16478@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0709101154310.24491@schroedinger.engr.sgi.com>
References: <18115.52863.638655.658466@cargo.ozlabs.ibm.com>
 <6370BBDF-0C79-41EB-BD2A-02AA0D216924@mac.com> <200709101438.36710.vda.linux@googlemail.com>
 <200709101516.03234.vda.linux@googlemail.com>
 <alpine.LFD.0.999.0709100807260.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007, Linus Torvalds wrote:

> The fact is, "volatile" *only* makes things worse. It generates worse 
> code, and never fixes any real bugs. This is a *fact*.

Yes, lets just drop the volatiles now! We need a patch that gets rid of 
them.... Volunteers?


