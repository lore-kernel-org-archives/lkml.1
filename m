Return-Path: <linux-kernel-owner+w=401wt.eu-S1758640AbXFTRyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640AbXFTRyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 13:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755587AbXFTRyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 13:54:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:33902 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbXFTRyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 13:54:44 -0400
From: Andi Kleen <ak@suse.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: Problem with global_flush_tlb() on i386 (x86_64? too) in 2.6.22-rc4-mm2
Date: Wed, 20 Jun 2007 19:53:53 +0200
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@redhat.com,
       mbligh@google.com
References: <20070619170914.GA30623@Krystal> <200706201101.20673.ak@suse.de> <20070620164614.GA8916@Krystal>
In-Reply-To: <20070620164614.GA8916@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706201953.54322.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 June 2007 18:46, Mathieu Desnoyers wrote:
> * Andi Kleen (ak@suse.de) wrote:
> > On Tuesday 19 June 2007 22:01:36 Mathieu Desnoyers wrote:
> > > Looking more closely into the code to find the cause of the
> > > change_page_addr()/global_flush_tlb() inconsistency, I see where the
> > > problem could be:
> >
> > Yes it's a known problem. I have a hack queued for .22 and there
> > are proposed patches for .23 too.
> >
> > ftp://ftp.firstfloor.org/pub/ak/x86_64/late-merge/patches/cpa-flush
> >
> > -ANdi
>
> Hi Andi,
>
> Although I cannot find it at the specified URL, I suspect it is already
> in Andrew's tree, in 2.6.22-rc4-mm2, under the name

Try again

> "x86_64-mm-cpa-cache-flush.patch"

No, that's a different patch with also at least one known bug.

-Andi
