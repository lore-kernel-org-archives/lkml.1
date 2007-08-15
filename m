Return-Path: <linux-kernel-owner+w=401wt.eu-S1763302AbXHOOec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763302AbXHOOec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 10:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758873AbXHOOeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 10:34:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46315 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758486AbXHOOeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 10:34:24 -0400
Date: Wed, 15 Aug 2007 16:34:22 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dkegel@google.com, David Miller <davem@davemloft.net>,
       Daniel Phillips <phillips@google.com>
Subject: Re: [RFC 0/3] Recursive reclaim (on __PF_MEMALLOC)
Message-ID: <20070815143422.GA653@one.firstfloor.org>
References: <20070814142103.204771292@sgi.com> <20070815122253.GA15268@wotan.suse.de> <1187183526.6114.45.camel@twins> <p731we43muw.fsf@bingen.suse.de> <1187186120.6114.56.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187186120.6114.56.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> That is his second patch-set, and I do worry about the irq latency that
> that will introduce. It very much has the potential to ruin everything
> that cares about interactiveness or latency.

I proposed a way to avoid increasing interrupt latency
in a simple way.

-Andi
