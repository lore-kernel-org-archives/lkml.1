Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbYICSqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbYICSqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 14:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756807AbYICSqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 14:46:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51419 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174AbYICSqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 14:46:18 -0400
Date: Wed, 3 Sep 2008 14:46:13 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Roland McGrath <roland@redhat.com>
Cc: Petr Tesarik <ptesarik@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] utrace core
Message-ID: <20080903184613.GD16175@infradead.org>
References: <20080826220102.89635154233@magilla.localdomain> <20080826220157.397C7154233@magilla.localdomain> <1220446707.6041.27.camel@elijah.suse.cz> <20080903180854.61207154228@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080903180854.61207154228@magilla.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 11:08:54AM -0700, Roland McGrath wrote:
> > Why does it depend on MODULES? 
> 
> Because otherwise it's not adding anything new anyone can use.

It doesn't add anything new to use either way

> > Does this mean that when ptrace is switched to using the utrace engines,
> > non-modular kernels will have to lack ptrace(2)?
> 
> No.  If that were done, then it would be:
> 	depends on MODULE || PTRACE
> or suchlike.
> 
> > Is there anything in the code that actually breaks without
> > CONFIG_MODULES?
> 
> No.

In which case you should just remove this bogus (non-)dependency.
