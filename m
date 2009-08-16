Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbZHPPAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbZHPPAZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 11:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbZHPPAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 11:00:24 -0400
Received: from www.tglx.de ([62.245.132.106]:59260 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbZHPPAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 11:00:24 -0400
Date: Sun, 16 Aug 2009 17:00:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Hellwig <hch@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [patch 00/11] Cleanup unload_nls() calls
In-Reply-To: <20090816144657.GA9549@infradead.org>
Message-ID: <alpine.LFD.2.00.0908161659450.2782@localhost.localdomain>
References: <20090814122657.114987508@linutronix.de> <20090816144657.GA9549@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Aug 2009, Christoph Hellwig wrote:

> On Fri, Aug 14, 2009 at 12:42:36PM -0000, Thomas Gleixner wrote:
> > While looking through the BKL call sites in fs/* I noticed that most
> > callsites of unload_nls() do 
> > 
> > 	  if (nls) 
> > 	     	   unload_nls(nls);
> > 
> > The patch series moves the NULL pointer check into unload_nls() and
> > cleans up the various users.
> 
> This looks all good to me.  But I'd just make it a single patch..

Sure, should go via Al, right ?

Thanks,

	tglx
 
