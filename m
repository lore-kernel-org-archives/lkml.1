Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbYJBNRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbYJBNRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 09:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbYJBNRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 09:17:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:54645 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbYJBNRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 09:17:03 -0400
Date: Thu, 2 Oct 2008 06:16:29 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20081002061629.39d5e115@infradead.org>
In-Reply-To: <20081002120444.GA25164@mit.edu>
References: <20081001200034.65eb67d6@infradead.org>
	<20081001215638.3a65134c.akpm@linux-foundation.org>
	<20081002062736.GR19428@kernel.dk>
	<20081001235501.2b7f50fe.akpm@linux-foundation.org>
	<20081002074523.GW19428@kernel.dk>
	<20081002010315.1cda8147.akpm@linux-foundation.org>
	<20081002120444.GA25164@mit.edu>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 08:04:44 -0400
Theodore Tso <tytso@mit.edu> wrote:

> 
> > But sometimes that doesn't work (including the place where I
> > knowingly broke it).  If we can find and fix the offending piece of
> > jbd logic (a big if) then all is peachy.
> 
> Do we have workloads that can easily demonstrate this problem?  If so,
> we can add some tracing code which will allow us to see which theory
> is correct, and what is actually happening.

I can very easily reproduce it; my mail client (claws) stalls due to
this several seconds at least once every 5 to 10 minutes...
(usually when I'm typing an email.. grumble)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
