Return-Path: <linux-kernel-owner+w=401wt.eu-S1762292AbXGJULL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762292AbXGJULL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 16:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758095AbXGJUK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 16:10:56 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:7386 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557AbXGJUKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 16:10:55 -0400
Date: Tue, 10 Jul 2007 21:10:11 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: William Tambe <tambewilliam@gmail.com>
cc: Stas Sergeev <stsp@aknet.ru>,
       "Rohland, Hans-Christoph" <hans-christoph.rohland@sap.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Concerning a post that you made about expandable anonymous shared
 mappings
In-Reply-To: <4692E5DF.7080304@gmail.com>
Message-ID: <Pine.LNX.4.64.0707102056140.4107@blonde.wat.veritas.com>
References: <468562F6.4010604@gmail.com> <Pine.LNX.4.64.0707021619020.32337@blonde.wat.veritas.com>
 <46893F97.7080200@aknet.ru> <Pine.LNX.4.64.0707031606370.16965@blonde.wat.veritas.com>
 <4692E5DF.7080304@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABGluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAaGFucy1jaHJpc3RvcGgucm9obGFuZEBzYXAuY29tAHRhbWJld2lsbGlhbUBnbWFpbC5jb20Ac3RzcEBha25ldC5ydQA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007, William Tambe wrote:
> Hugh Dickins wrote:
> > 
> > I've come right around to your original view, Stas, and William's:
> > if that mmap creates such an object, then the expanding mremap really
> > ought to be useful, and allow the underlying object to be expanded.
> > The shared anonymous object is already anomalous: expanding it on
> > fault makes it more consistent with its own nature, not less.
> > ...
> > Here's a patch against 2.6.22-rc7: would you, Stas, put your
> > Signed-off-by into this, and accept authorship - although I'm
> > sending this back to you, it's very much your idea, and only
> > trivially modified from your three-year-old patch by me.  If
> > you're agreeable, I can then forward it or its shmem_zero_fault
> > equivalent to Andrew when we see which way 2.6.23 is going.
>... 
> Will this patch be added to stable versions of the linux kernel?
> Please let me know.

I confess that the lukewarm response from Stas cooled my enthusiasm,
and left me feeling that perhaps I'm an idiot to be adding such a
feature so many years too late; and my old caution about the way
a child could use up memory not freed on child's exit, unknown to
parent, returned to haunt me.  That could be documented for new
usages, but I just don't know what usages are already out there,
and fear I'd be introducing an exploit.

It most certainly will not be added to a stable version of the
linux kernel, if by that you mean 2.6.22.N or 2.6.21.N etc.
Though it can be viewed as a bugfix, the patch as it stands
seems in danger of introducing its own bug, and it's just too
much of a feature to be suitable for a -stable release.

But more probably you meant, will it be in 2.6.23 or 2.6.24?
Sorry to be such a vacillatiing wimp, but I don't know.
How well are you managing with the shm_open approach?

Hugh
