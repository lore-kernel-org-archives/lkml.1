Return-Path: <linux-kernel-owner+w=401wt.eu-S933823AbZGQARt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933823AbZGQARt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933739AbZGQARt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:17:49 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48562 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933727AbZGQARs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:17:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: Warn once when a page is freed with PG_mlocked set V2
Cc: kosaki.motohiro@jp.fujitsu.com,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <20090716160139.GB1883@cmpxchg.org>
References: <alpine.DEB.1.10.0907160949470.32382@gentwo.org> <20090716160139.GB1883@cmpxchg.org>
Message-Id: <20090717091653.A909.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 17 Jul 2009 09:17:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Jul 16, 2009 at 09:54:49AM -0400, Christoph Lameter wrote:
> > On Thu, 16 Jul 2009, KOSAKI Motohiro wrote:
> > 
> > > I like this patch. but can you please separate two following patches?
> > >   - introduce __TESTCLEARFLAG()
> > >   - non-atomic test-clear of PG_mlocked on free
> > 
> > That would mean introducing the macro without any use case? It is fine the
> > way it is I think.
> 
> Yeah, it's borderline.  In any case, I have the split version here as
> well.  Andrew, you choose :)
> 
> > Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
> 
> Thanks,

OK, I can agree with Christoph. you don't need change the patch.

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


