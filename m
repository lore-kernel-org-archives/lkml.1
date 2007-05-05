Return-Path: <linux-kernel-owner+w=401wt.eu-S1423259AbXEEJk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423259AbXEEJk7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 05:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423264AbXEEJk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 05:40:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:34034 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423259AbXEEJk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 05:40:58 -0400
To: clameter@sgi.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, dgc@sgi.com,
       Eric Dumazet <dada1@cosmosbay.com>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC 2/3] SLUB: Implement targeted reclaim and partial list defragmentation
References: <20070504221555.642061626@sgi.com>
	<20070504221708.596112123@sgi.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 05 May 2007 12:38:25 +0200
In-Reply-To: <20070504221708.596112123@sgi.com>
Message-ID: <p738xc3wo66.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

clameter@sgi.com writes:
> 
> NOTE: This patch is for conceptual review. I'd appreciate any feedback
> especially on the locking approach taken here. It will be critical to
> resolve the locking issue for this approach to become feasable.

Do you have any numbers on how this improves dcache reclaim under memory pressure?

-Andi
