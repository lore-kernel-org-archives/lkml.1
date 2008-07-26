Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbYGZFfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbYGZFfR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 01:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYGZFfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 01:35:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42715 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbYGZFfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 01:35:03 -0400
Date: Sat, 26 Jul 2008 01:34:59 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] byteorder: force in-place endian conversion to always
	evaluate args
Message-ID: <20080726053459.GA26063@infradead.org>
References: <1217003621.5971.4.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217003621.5971.4.camel@brick>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 09:33:41AM -0700, Harvey Harrison wrote:
> David Miller reported breakage in ide when the in-place byteorder helpers
> were used as the macros do not always evaluate their args which led to
> an infinite loop.
> 
> Just make them functions to ensure they always do so.

Of course the best thing would be to kill these macros entirely.
In-place endianess conversions are bad idea.

