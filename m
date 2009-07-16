Return-Path: <linux-kernel-owner+w=401wt.eu-S932556AbZGPQC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556AbZGPQC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 12:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932454AbZGPQC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 12:02:57 -0400
Received: from cmpxchg.org ([85.214.51.133]:45049 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932438AbZGPQC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 12:02:57 -0400
Date: Thu, 16 Jul 2009 18:01:39 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] mm: Warn once when a page is freed with PG_mlocked set V2
Message-ID: <20090716160139.GB1883@cmpxchg.org>
References: <alpine.DEB.1.10.0907151027410.23643@gentwo.org> <20090715220445.GA1823@cmpxchg.org> <20090716163537.9D3D.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0907160949470.32382@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0907160949470.32382@gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 09:54:49AM -0400, Christoph Lameter wrote:
> On Thu, 16 Jul 2009, KOSAKI Motohiro wrote:
> 
> > I like this patch. but can you please separate two following patches?
> >   - introduce __TESTCLEARFLAG()
> >   - non-atomic test-clear of PG_mlocked on free
> 
> That would mean introducing the macro without any use case? It is fine the
> way it is I think.

Yeah, it's borderline.  In any case, I have the split version here as
well.  Andrew, you choose :)

> Reviewed-by: Christoph Lameter <cl@linux-foundation.org>

Thanks,

	Hannes
