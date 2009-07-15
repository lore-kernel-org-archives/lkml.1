Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbZGOTz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbZGOTz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 15:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbZGOTz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 15:55:56 -0400
Received: from smtp-out.google.com ([216.239.45.13]:20447 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174AbZGOTzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 15:55:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=aHGX5awAe3QxdBjGf7X/V2FZbGls/nc5r6p8/x4QiPmYyPtxbAjqlrO0/PqSD43qq
	sUjShe9D+pGanaAIR00Dw==
Date: Wed, 15 Jul 2009 12:55:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linux Memory Management List <linux-mm@kvack.org>,
       Heinz Diehl <htd@fancy-poultry.org>, David Miller <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/3] page-allocator: Allow too high-order warning messages
 to be suppressed with __GFP_NOWARN
In-Reply-To: <1247656992-19846-2-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.0907151255290.20452@chino.kir.corp.google.com>
References: <1247656992-19846-1-git-send-email-mel@csn.ul.ie> <1247656992-19846-2-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009, Mel Gorman wrote:

> The page allocator warns once when an order >= MAX_ORDER is specified.
> This is to catch callers of the allocator that are always falling back
> to their worst-case when it was not expected. However, there are cases
> where the caller is behaving correctly but cannot suppress the warning.
> This patch allows the warning to be suppressed by the callers by
> specifying __GFP_NOWARN.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Acked-by: David Rientjes <rientjes@google.com>
