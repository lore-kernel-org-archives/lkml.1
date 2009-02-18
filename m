Return-Path: <linux-kernel-owner+w=401wt.eu-S1753771AbZBRKzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbZBRKzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 05:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbZBRKyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 05:54:52 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35519 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbZBRKyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 05:54:51 -0500
Subject: Re: [patch 1/7] slab: introduce kzfree()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Vrabel <david.vrabel@csr.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chas Williams <chas@cmf.nrl.navy.mil>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <499BE7F8.80901@csr.com>
References: <20090217182615.897042724@cmpxchg.org>
	 <20090217184135.747921027@cmpxchg.org>  <499BE7F8.80901@csr.com>
Date: Wed, 18 Feb 2009 12:54:48 +0200
Message-Id: <1234954488.24030.46.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-18 at 10:50 +0000, David Vrabel wrote:
> Johannes Weiner wrote:
> > +void kzfree(const void *p)
> 
> Shouldn't this be void * since it writes to the memory?

No. kfree() writes to the memory as well to update freelists, poisoning
and such so kzfree() is not at all different from it.

