Return-Path: <linux-kernel-owner+w=401wt.eu-S1759632AbYD3JTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759632AbYD3JTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 05:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756756AbYD3JTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 05:19:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51736 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559AbYD3JTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 05:19:01 -0400
Date: Wed, 30 Apr 2008 05:19:00 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] s390: Remove self ptrace IEEE_IP hack.
Message-ID: <20080430091900.GA13743@infradead.org>
References: <1209546896.10954.28.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209546896.10954.28.camel@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 11:14:56AM +0200, Martin Schwidefsky wrote:
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> The self referential PT_IEEE_IP ptrace peek & poke calls have been
> broken for that last 6 years. For peek the code always returns 0
> instead of the last ieee fault and for poke the code does nothing.
> Since nobody noticed the code seems to be superfluous. So lets
> remove it.

After this the switch to the generic sys_ptrace is trivial.  Care to
submit a patch for that aswell?

