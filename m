Return-Path: <linux-kernel-owner+w=401wt.eu-S1759254AbYE3ASK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759254AbYE3ASK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 20:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbYE3AR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 20:17:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbYE3ARz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 20:17:55 -0400
Message-ID: <483F4794.9040807@redhat.com>
Date: Thu, 29 May 2008 19:17:24 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Michael Halcrow <mhalcrow@us.ibm.com>, shaggy@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] eCryptfs: Remove unnecessary page decrypt call
References: <20080529220817.GF7450@halcrowt61p.austin.ibm.com> <20080529163643.4c2620fb.akpm@linux-foundation.org>
In-Reply-To: <20080529163643.4c2620fb.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 29 May 2008 17:08:17 -0500
> Michael Halcrow <mhalcrow@us.ibm.com> wrote:
> 
>> The page decrypt calls in ecryptfs_write() are both pointless and
>> buggy.
> 
> buggy enough to be fixed in 2.6.26?  2.6.25.x?

IMHO yes... fsx w/ mmap dies quickly ( < 100 ops) without this, and
survives nicely (to millions of ops+) with it in place.

-Eric
