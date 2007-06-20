Return-Path: <linux-kernel-owner+w=401wt.eu-S1762148AbXFTJBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762148AbXFTJBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 05:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754530AbXFTJB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 05:01:26 -0400
Received: from mx1.suse.de ([195.135.220.2]:43263 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754373AbXFTJBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 05:01:25 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: Problem with global_flush_tlb() on i386 (x86_64? too) in 2.6.22-rc4-mm2
Date: Wed, 20 Jun 2007 11:01:20 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@redhat.com,
       mbligh@google.com
References: <20070619170914.GA30623@Krystal> <20070619200136.GA4943@Krystal>
In-Reply-To: <20070619200136.GA4943@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706201101.20673.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 June 2007 22:01:36 Mathieu Desnoyers wrote:
> Looking more closely into the code to find the cause of the
> change_page_addr()/global_flush_tlb() inconsistency, I see where the
> problem could be:

Yes it's a known problem. I have a hack queued for .22 and there
are proposed patches for .23 too.

ftp://ftp.firstfloor.org/pub/ak/x86_64/late-merge/patches/cpa-flush

-ANdi
