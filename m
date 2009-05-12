Return-Path: <linux-kernel-owner+w=401wt.eu-S1757117AbZELPnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117AbZELPnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbZELPnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:43:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:34591 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbZELPnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:43:42 -0400
Message-ID: <4A09991E.9010903@kernel.org>
Date: Wed, 13 May 2009 00:43:26 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: remap allocator for per-CPU memory
References: <4A09B23B02000078000007F1@vpn.id2.novell.com>
In-Reply-To: <4A09B23B02000078000007F1@vpn.id2.novell.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 12 May 2009 15:43:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Didn't the addition of this allocator introduce another case that
> needs special treatment in pageattr.c? Since large pages are used
> for mapping the allocated memory, but only part of the initially
> allocated large pages are actually retained, there's now the
> potential for TLB aliases with different cache attributes for those
> parts of these pages that get passed back through free_bootmem().

Hmmm.... yes, the large page mapping and the returned part of it would
alias each other.  What changes should be made for it?  Dunno much
about how pageattr works.

Thanks.

-- 
tejun
