Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbXFYI6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbXFYI6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 04:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbXFYI6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 04:58:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34022 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbXFYI63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 04:58:29 -0400
Date: Mon, 25 Jun 2007 10:58:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/3] add the fsblock layer
Message-ID: <20070625085826.GA19928@one.firstfloor.org>
References: <20070624014528.GA17609@wotan.suse.de> <20070624014613.GB17609@wotan.suse.de> <p73fy4h5q3c.fsf@bingen.suse.de> <1182716322.6819.3.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182716322.6819.3.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 01:18:42PM -0700, Arjan van de Ven wrote:
> 
> > Hmm, could define a macro DECLARE_ATOMIC_BITMAP(maxbit) that expands to the smallest
> > possible type for each architecture. And a couple of ugly casts for set_bit et.al.
> > but those could be also hidden in macros. Should be relatively easy to do.
> 
> or make a "smallbit" type that is small/supported, so 64 bit if 32 bit
> isn't supported, otherwise 32

That wouldn't handle the case where you only need e.g. 8 bits
That's fine for x86 too. It only hates atomic accesses crossing cache line
boundaries (but handles them too, just slow) 

-Andi
