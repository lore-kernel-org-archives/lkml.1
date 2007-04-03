Return-Path: <linux-kernel-owner+w=401wt.eu-S965959AbXDCR2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965959AbXDCR2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966021AbXDCR2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:28:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54779 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965959AbXDCR2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:28:42 -0400
Date: Tue, 3 Apr 2007 19:28:41 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jakub Jelinek <jakub@redhat.com>
Subject: Re: missing madvise functionality
Message-ID: <20070403172841.GB23689@one.firstfloor.org>
References: <46128051.9000609@redhat.com> <p73648dz5oa.fsf@bingen.suse.de> <46128CC2.9090809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46128CC2.9090809@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 10:20:02AM -0700, Ulrich Drepper wrote:
> Andi Kleen wrote:
> > Why do you need a lock for that? I don't see any problem with
> > two threads doing that in parallel. The kernel would
> > serialize it internally and one would fail, but that shouldn't
> > be a problem. 
> 
> There is no lock at all at userlevel.  I'm talking about locks in the
> kernel.

mmap_sem? Your new operation wouldn't solve that neither.

There were some proposals to fix mmap_sem (it's a big issue
for futexes too) but they're are quite involved.

-Andi
