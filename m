Return-Path: <linux-kernel-owner+w=401wt.eu-S1758953AbXIISVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953AbXIISVo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 14:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758861AbXIISVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 14:21:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58277 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758818AbXIISV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 14:21:28 -0400
Date: Sun, 9 Sep 2007 19:18:39 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <piggin@cyberone.com.au>,
       Satyam Sharma <satyam@infradead.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Paul Mackerras <paulus@samba.org>, Christoph Lameter <clameter@sgi.com>,
       Chris Snook <csnook@redhat.com>,
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
Message-ID: <20070909191839.1fa10e88@laptopd505.fenrus.org>
In-Reply-To: <200709091902.55388.vda.linux@googlemail.com>
References: <18115.52863.638655.658466@cargo.ozlabs.ibm.com>
	<46C59717.4020108@cyberone.com.au>
	<alpine.LFD.0.999.0708170929580.30176@woody.linux-foundation.org>
	<200709091902.55388.vda.linux@googlemail.com>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Sep 2007 19:02:54 +0100
Denys Vlasenko <vda.linux@googlemail.com> wrote:

> Why is all this fixation on "volatile"? I don't think
> people want "volatile" keyword per se, they want atomic_read(&x) to
> _always_ compile into an memory-accessing instruction, not register
> access.

and ... why is that?
is there any valid, non-buggy code sequence that makes that a
reasonable requirement?
