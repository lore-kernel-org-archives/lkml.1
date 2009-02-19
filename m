Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566AbZBSBWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbZBSBWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 20:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbZBSBWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 20:22:31 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51302 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbZBSBWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 20:22:30 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [patch 1/7] slab: introduce kzfree()
Cc: kosaki.motohiro@jp.fujitsu.com, David Vrabel <david.vrabel@csr.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chas Williams <chas@cmf.nrl.navy.mil>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <1234954488.24030.46.camel@penberg-laptop>
References: <499BE7F8.80901@csr.com> <1234954488.24030.46.camel@penberg-laptop>
Message-Id: <20090219101336.9556.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Thu, 19 Feb 2009 10:22:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2009-02-18 at 10:50 +0000, David Vrabel wrote:
> > Johannes Weiner wrote:
> > > +void kzfree(const void *p)
> > 
> > Shouldn't this be void * since it writes to the memory?
> 
> No. kfree() writes to the memory as well to update freelists, poisoning
> and such so kzfree() is not at all different from it.

I don't think so. It's debetable thing.

poisonig is transparent feature from caller.
but the caller of kzfree() know to fill memory and it should know.



