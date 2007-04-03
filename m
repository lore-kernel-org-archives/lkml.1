Return-Path: <linux-kernel-owner+w=401wt.eu-S1945944AbXDCVXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945944AbXDCVXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 17:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945951AbXDCVXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 17:23:10 -0400
Received: from gw.goop.org ([64.81.55.164]:45804 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945944AbXDCVXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 17:23:09 -0400
Message-ID: <4612C5AC.2070008@goop.org>
Date: Tue, 03 Apr 2007 14:22:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jakub Jelinek <jakub@redhat.com>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com>	<p73648dz5oa.fsf@bingen.suse.de>	<46128CC2.9090809@redhat.com>	<20070403172841.GB23689@one.firstfloor.org>	<20070403125903.3e8577f4.akpm@linux-foundation.org>	<4612B645.7030902@redhat.com> <20070403135154.61e1b5f3.akpm@linux-foundation.org> <4612C059.8070702@redhat.com> <4612C2B6.3010302@cosmosbay.com>
In-Reply-To: <4612C2B6.3010302@cosmosbay.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> mmap()/brk() must give fresh NULL pages, but maybe
> madvise(MADV_DONTNEED) can relax this requirement (if the pages were
> reclaimed, then a page fault could bring a new page with random content) 

Only if those pages were originally from that process.  Otherwise you've
got a bit of an information leak there.

    J
