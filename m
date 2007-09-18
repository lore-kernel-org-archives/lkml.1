Return-Path: <linux-kernel-owner+w=401wt.eu-S1756985AbXIRWpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbXIRWpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 18:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759857AbXIRWov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 18:44:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38927 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759540AbXIRWot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 18:44:49 -0400
Date: Wed, 19 Sep 2007 00:44:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 4/7] Immediate Values - i386 Optimization
Message-ID: <20070918224444.GC5773@one.firstfloor.org>
References: <20070918210747.828804366@polymtl.ca> <20070918210853.588573678@polymtl.ca> <46F04856.3010808@goop.org> <p73myvjwri3.fsf@bingen.suse.de> <46F0515E.2010608@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F0515E.2010608@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 03:29:50PM -0700, Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> > Jeremy Fitzhardinge <jeremy@goop.org> writes:
> >   
> >> It's a pity that gas seems to generate plain 0x90 nops rather than
> >> long-nop forms here.  I thought it could do that.
> >>     
> >
> > .p2align does it
> 
> Just .p2align?  Not align, balign, org or skip?  Seems... strange.

The problem is that you cannot always safely jump into the middle of the 
longer form nops. So I suppose they didn't risk breakage on older
code relying on this.

-Andi
