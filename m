Return-Path: <linux-kernel-owner+w=401wt.eu-S1945927AbXDCUih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945927AbXDCUih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 16:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945929AbXDCUih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 16:38:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945927AbXDCUig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 16:38:36 -0400
Message-ID: <4612BB44.3060100@redhat.com>
Date: Tue, 03 Apr 2007 16:38:28 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Jakub Jelinek <jakub@redhat.com>
CC: Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com> <p73648dz5oa.fsf@bingen.suse.de> <46128CC2.9090809@redhat.com> <20070403172841.GB23689@one.firstfloor.org> <20070403125903.3e8577f4.akpm@linux-foundation.org> <4612B645.7030902@redhat.com> <20070403202937.GE355@devserv.devel.redhat.com>
In-Reply-To: <20070403202937.GE355@devserv.devel.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jakub Jelinek wrote:

> My guess is that all the page zeroing is pretty expensive as well and
> takes significant time, but I haven't profiled it.

I'm pretty sure that page freeing, reallocating and zeroing
is more expensive than just letting the page sit there and
only reclaim it lazily when we need the memory.

I'll try to whip up a patch this week.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
