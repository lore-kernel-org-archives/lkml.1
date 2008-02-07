Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbYBGMwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbYBGMwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 07:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbYBGMwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 07:52:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42624 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805AbYBGMwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:52:33 -0500
Date: Thu, 7 Feb 2008 13:52:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] x86 mmiotrace: use lookup_address()
Message-ID: <20080207125221.GA27234@elte.hu>
References: <1201660102.8837.9.camel@brick> <1201660453.8837.13.camel@brick> <20080130200827.322c4f7d@daedalus.pq.iki.fi> <20080131150746.GB11996@elte.hu> <20080131180253.6c007852@daedalus.pq.iki.fi> <20080131081507.5edcde10@laptopd505.fenrus.org> <20080203085522.2b63e15b@daedalus.pq.iki.fi> <20080203070321.GA8293@elte.hu> <20080205222807.7b35ef2b@daedalus.pq.iki.fi> <20080206050028.GA18700@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206050028.GA18700@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Feb 05, 2008 at 10:28:07PM +0200, Pekka Paalanen wrote:
> > Use lookup_address() from pageattr.c instead of doing the same
> > manually. Also had to EXPORT_SYMBOL(lookup_address) to make this
> > work for modules. This also fixes "undefined symbol 'init_mm'"
> > compile error for x86_32.
> 
> This should be a _GPL export for sure.

i've changed it to that.

	Ingo
