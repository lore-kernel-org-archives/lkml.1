Return-Path: <linux-kernel-owner+w=401wt.eu-S1752583AbYITPp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbYITPp3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 11:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbYITPpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 11:45:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:51211 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbYITPpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 11:45:10 -0400
Date: Sat, 20 Sep 2008 08:45:12 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jens.axboe@oracle.com,
       steffen.klassert@secunet.com
Subject: Re: [PATCH 0/2]: Remote softirq invocation infrastructure.
Message-ID: <20080920084512.58f7fb08@infradead.org>
In-Reply-To: <1221924561.1343.121.camel@localhost.localdomain>
References: <20080919.234824.223177211.davem@davemloft.net>
	<1221924561.1343.121.camel@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Sep 2008 08:29:21 -0700
> 
> > Jen's, as stated, has block layer uses for this.  I intend to use
> > this for receive side flow seperation on non-multiqueue network
> > cards.  And Steffen Klassert has a set of IPSEC parallelization
> > changes that can very likely make use of this.
> 
> What's the benefit that you (or Jens) sees from migrating softirqs
> from specific cpu's to others?

it means you do all the processing on the CPU that submitted the IO in
the first place, and likely still has the various metadata pieces in
its CPU cache (or at least you know you won't need to bounce them over)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
