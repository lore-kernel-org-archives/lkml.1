Return-Path: <linux-kernel-owner+w=401wt.eu-S1752680AbYBFFAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbYBFFAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 00:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829AbYBFFAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 00:00:31 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38355 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbYBFFAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 00:00:30 -0500
Date: Wed, 6 Feb 2008 00:00:28 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Pekka Paalanen <pq@iki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] x86 mmiotrace: use lookup_address()
Message-ID: <20080206050028.GA18700@infradead.org>
References: <20080127185238.4bcac54b@daedalus.pq.iki.fi> <1201660102.8837.9.camel@brick> <1201660453.8837.13.camel@brick> <20080130200827.322c4f7d@daedalus.pq.iki.fi> <20080131150746.GB11996@elte.hu> <20080131180253.6c007852@daedalus.pq.iki.fi> <20080131081507.5edcde10@laptopd505.fenrus.org> <20080203085522.2b63e15b@daedalus.pq.iki.fi> <20080203070321.GA8293@elte.hu> <20080205222807.7b35ef2b@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205222807.7b35ef2b@daedalus.pq.iki.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2008 at 10:28:07PM +0200, Pekka Paalanen wrote:
> Use lookup_address() from pageattr.c instead of doing the same
> manually. Also had to EXPORT_SYMBOL(lookup_address) to make this
> work for modules. This also fixes "undefined symbol 'init_mm'"
> compile error for x86_32.

This should be a _GPL export for sure.

