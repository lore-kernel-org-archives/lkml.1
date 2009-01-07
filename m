Return-Path: <linux-kernel-owner+w=401wt.eu-S1760114AbZAGCnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760114AbZAGCnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 21:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756413AbZAGCn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 21:43:28 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48562 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979AbZAGCn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 21:43:27 -0500
Date: Wed, 7 Jan 2009 03:57:25 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29 -mm merge plans
Message-ID: <20090107025725.GJ496@one.firstfloor.org>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <20090106225744.GA10553@infradead.org> <20090106151131.b6c4ff0b.akpm@linux-foundation.org> <20090106232418.GB25103@infradead.org> <20090107011448.GB3390@wotan.suse.de> <87tz8b3nfe.fsf@basil.nowhere.org> <20090107014915.GE3390@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107014915.GE3390@wotan.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> sys_sync B which is invoked *after* sys_sync caller A should not
> return before A. If you didn't have a global lock, they'd tend to
> block one another's pages anyway. I think it's OK.

It means that you cannot reboot because reboot does sync.
What happens when the sync gets stuck somewhere on a really
slow device?

-Andi

-- 
ak@linux.intel.com
