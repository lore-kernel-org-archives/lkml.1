Return-Path: <linux-kernel-owner+w=401wt.eu-S1946003AbXDCWIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946003AbXDCWIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 18:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbXDCWIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 18:08:40 -0400
Received: from lazybastard.de ([212.112.238.170]:50382 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbXDCWIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 18:08:40 -0400
Date: Tue, 3 Apr 2007 23:12:38 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jakub Jelinek <jakub@redhat.com>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: missing madvise functionality
Message-ID: <20070403211238.GB26860@lazybastard.org>
References: <46128051.9000609@redhat.com> <p73648dz5oa.fsf@bingen.suse.de> <46128CC2.9090809@redhat.com> <20070403172841.GB23689@one.firstfloor.org> <20070403125903.3e8577f4.akpm@linux-foundation.org> <4612B645.7030902@redhat.com> <20070403135154.61e1b5f3.akpm@linux-foundation.org> <4612C059.8070702@redhat.com> <4612C2B6.3010302@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4612C2B6.3010302@cosmosbay.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 April 2007 23:10:14 +0200, Eric Dumazet wrote:
> 
> mmap()/brk() must give fresh NULL pages, but maybe madvise(MADV_DONTNEED) 
> can relax this requirement (if the pages were reclaimed, then a page fault 
> could bring a new page with random content)

...provided that it doesn't leak information from the kernel?

Jörn

-- 
All art is but imitation of nature.
-- Lucius Annaeus Seneca
