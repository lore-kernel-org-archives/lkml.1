Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbXITV2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbXITV2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 17:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbXITV2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 17:28:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56858 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751971AbXITV2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 17:28:24 -0400
Date: Thu, 20 Sep 2007 14:17:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: cpw@sgi.com (Cliff Wickman)
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][VER 4] mspec: handle shrinking virtual memory areas
Message-Id: <20070920141740.aaa4d1d4.akpm@linux-foundation.org>
In-Reply-To: <20070920203335.013542166F4@attica.americas.sgi.com>
References: <20070920203335.013542166F4@attica.americas.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007 15:33:34 -0500
cpw@sgi.com (Cliff Wickman) wrote:

> Stress testing revealed the need for more revision.
> This is a revision of Andrew's mspec-handle-shrinking-virtual-memory-areas.patch
> 
> Version 4: clear/release fetchop pages only when vma_data is no longer shared
> 
> Version 3: single thread the clearing of vma_data maddr[]
> Version 2: refcount maintained as atomic_t (as before the version 1 patch)
> 

Boy am I getting tired of this patch :(

Version #3943 was just merged into mainline, so can you please prepare
a diff against Linus's tree for #3944?

Ta.
