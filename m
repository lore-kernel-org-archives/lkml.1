Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbXJaIPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbXJaIPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 04:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbXJaIPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 04:15:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33037 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbXJaIPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 04:15:18 -0400
Date: Wed, 31 Oct 2007 08:15:13 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] dump_stack on panic
Message-ID: <20071031081513.GB3810@infradead.org>
References: <1193788979.5623.43.camel@localhost.localdomain> <p73odeg2l9v.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73odeg2l9v.fsf@bingen.suse.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2007 at 01:14:04AM +0100, Andi Kleen wrote:
> One (mostly psychological, but still serious) problem is that stack
> dumps make panics always look like kernel bugs.  But there are panics
> which are definitely not kernel bugs: like the popular cannot mount
> root or machine checks or a couple of others.

But that one really shouldn't be a panic anyway.  The panic alone
is psycologically bad enough for users.  I think it would be best to
have a simple scanf loop asking for another root device..

