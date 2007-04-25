Return-Path: <linux-kernel-owner+w=401wt.eu-S1423325AbXDYI7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423325AbXDYI7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 04:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423329AbXDYI7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 04:59:39 -0400
Received: from ns2.suse.de ([195.135.220.15]:53658 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423325AbXDYI7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 04:59:38 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Fernando Luis =?iso-8859-15?q?V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
Subject: Re: [PATCH] mm: PageLRU can be non-atomic bit operation
Date: Wed, 25 Apr 2007 10:59:24 +0200
User-Agent: KMail/1.9.6
Cc: Hugh Dickins <hugh@veritas.com>,
       Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <6.0.0.20.2.20070423193641.0457f700@172.19.0.2> <200704241622.30773.ak@suse.de> <1177491416.15618.7.camel@sebastian.intellilink.co.jp>
In-Reply-To: <1177491416.15618.7.camel@sebastian.intellilink.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704251059.24994.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> This seems to imply that we need the lock prefix even when updating
> different bits within the same long (not just the same byte). Is this
> interpretation correct?

Yes, that is what I said. The consistency applies to loads/stores
(so e.g. for 128bit SSE2 load/stores too), not bytes.

The current IA32 manuals have a more detailed description of the rules 
in volume 3

-Andi
