Return-Path: <linux-kernel-owner+w=401wt.eu-S2993251AbXECPSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993251AbXECPSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993254AbXECPSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:18:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48640 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993244AbXECPSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:18:04 -0400
Date: Thu, 3 May 2007 16:17:56 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Keir Fraser <Keir.Fraser@cl.cam.ac.uk>
Subject: Re: netfront for review
Message-ID: <20070503151756.GA29629@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Keir Fraser <Keir.Fraser@cl.cam.ac.uk>
References: <4637D672.5030706@goop.org> <1178077033.28659.173.camel@localhost.localdomain> <4638EAC0.7020107@goop.org> <46399057.4000409@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46399057.4000409@redhat.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 09:33:43AM +0200, Gerd Hoffmann wrote:
> >Guess so.  It defaults to flip.  I simplified the rx_copy/flip module
> >parameter to a simple rx_mode=0/1, but this is preserved from the
> >original.  My guess is that originally there was only flip, and copy was
> >added later.
> 
> Yep, page flipping is the old (pre xen 3.0.3) way, copy was added (and 
> made the default) later.

So can we please just rip out the obsolete code completely?  There's
no point adding this code anymore.

