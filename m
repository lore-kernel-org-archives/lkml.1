Return-Path: <linux-kernel-owner+w=401wt.eu-S969436AbXEHXGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969436AbXEHXGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 19:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968588AbXEHXGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 19:06:07 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968763AbXEHXGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 19:06:03 -0400
Date: Tue, 8 May 2007 16:05:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Jakub Jelinek <jakub@redhat.com>,
       Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] stub MADV_FREE implementation
Message-Id: <20070508160547.e1576146.akpm@linux-foundation.org>
In-Reply-To: <463FF3D3.9060007@redhat.com>
References: <4632D0EF.9050701@redhat.com>
	<463B108C.10602@yahoo.com.au>
	<463B598B.80200@redhat.com>
	<463BC62C.3060605@yahoo.com.au>
	<463FF3D3.9060007@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 May 2007 23:51:47 -0400
Rik van Riel <riel@redhat.com> wrote:

> Until we have better performance numbers on the lazy reclaim path,
> we can just alias MADV_FREE to MADV_DONTNEED with this trivial
> patch.
> 
> This way glibc can go ahead with the optimization on their side
> and we can figure out the kernel side later.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>

Could someone please explain what is going on here?


And has Ulrich indicated that glibc would indeed go out ahead of
the kernel in this fashion?
