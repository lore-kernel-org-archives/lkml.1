Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbZHPOq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbZHPOq5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 10:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbZHPOq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 10:46:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41363 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbZHPOq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 10:46:56 -0400
Date: Sun, 16 Aug 2009 10:46:57 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 00/11] Cleanup unload_nls() calls
Message-ID: <20090816144657.GA9549@infradead.org>
References: <20090814122657.114987508@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090814122657.114987508@linutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 12:42:36PM -0000, Thomas Gleixner wrote:
> While looking through the BKL call sites in fs/* I noticed that most
> callsites of unload_nls() do 
> 
> 	  if (nls) 
> 	     	   unload_nls(nls);
> 
> The patch series moves the NULL pointer check into unload_nls() and
> cleans up the various users.

This looks all good to me.  But I'd just make it a single patch..

