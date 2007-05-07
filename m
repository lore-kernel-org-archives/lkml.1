Return-Path: <linux-kernel-owner+w=401wt.eu-S1753694AbXEGCmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbXEGCmv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 22:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbXEGCmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 22:42:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670AbXEGCmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 22:42:50 -0400
Message-ID: <463E921D.3070407@redhat.com>
Date: Sun, 06 May 2007 19:42:37 -0700
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
References: <4632D0EF.9050701@redhat.com> <463B108C.10602@yahoo.com.au> <463B598B.80200@redhat.com> <463BC62C.3060605@yahoo.com.au> <463E5A00.6070708@redhat.com>
In-Reply-To: <463E5A00.6070708@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> I think that maybe for 2.6.22 we should just alias MADV_FREE
> to run with the MADV_DONTNEED functionality, so that the glibc
> people can make the change on their side while we figure out
> what will be the best thing to do on the kernel side.

No need for that.  We can later extend glibc to use MADV_FREE and fall 
back on MADV_DONTNEED.

-- 
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
