Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbXEGExg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbXEGExg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 00:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbXEGExg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 00:53:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932AbXEGExg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 00:53:36 -0400
Message-ID: <463EB0C4.6060901@redhat.com>
Date: Sun, 06 May 2007 21:53:24 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH] MM: implement MADV_FREE lazy freeing of anonymous memory
References: <4632D0EF.9050701@redhat.com> <463B108C.10602@yahoo.com.au> <463B598B.80200@redhat.com> <463BC62C.3060605@yahoo.com.au> <463E5A00.6070708@redhat.com> <463E921D.3070407@redhat.com> <463EB169.8030701@redhat.com>
In-Reply-To: <463EB169.8030701@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> It's trivial to merge the MADV_FREE #defines into the kernel
> though, and aliasing MADV_FREE to MADV_DONTNEED for the time
> being is a one-liner - just an extra constant into the big
> switch statement in sys_madvise().

Until the semantics of the implementation is cut into stone by having it 
in the kernel I'll not start using it.

-- 
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
