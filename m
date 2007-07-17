Return-Path: <linux-kernel-owner+w=401wt.eu-S934192AbXGQQNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934192AbXGQQNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 12:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760514AbXGQQNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 12:13:36 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:19063 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758740AbXGQQNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 12:13:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=o2IWojMn9MhRvbQL55MuyiYr0qlEh1k4HyWHYhEB5+tshS0XqydXAOddjoQ8u+ZxvuSmswUN7kPJd1I1sUPpxrTsjb45epjef7xRmRkPGt8Hsht29WzHXvrS5+REedjSYQgJ7E29nxA/HJg1MzwdusYwKZKHbFhc/N6FhAF3FKo=
Date: Tue, 17 Jul 2007 11:14:54 -0500
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Rene Herman <rene.herman@gmail.com>
Cc: Ray Lee <ray-lk@madrabbit.org>, Bodo Eggert <7eggert@gmx.de>,
       Matt Mackall <mpm@selenic.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Message-ID: <20070717161454.GB21538@mediacenter.austin.rr.com>
References: <E1IA7j1-0000j9-I3@be1.lrz> <469A5D7C.5010904@gmail.com> <Pine.LNX.4.58.0707161523500.25779@be1.lrz> <469BF104.1040703@gmail.com> <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com> <469BF768.6040200@gmail.com> <2c0942db0707161613lff9c07bpcf002b9139163a86@mail.gmail.com> <469BFDA7.1040204@gmail.com> <2c0942db0707161640h3c3afd7avecd7b3c61c4e7df1@mail.gmail.com> <469C1409.9010305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469C1409.9010305@gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 02:57:45AM +0200, Rene Herman wrote:
>  True enough. I'm rather wondering though why RHEL is shipping with it if 
>  it's a _real_ problem. Scribbling junk all over kernel memory would be the 
>  kind of thing I'd imagine you'd mightely piss-off enterprise customers with. 
>  But well, sure, that rather quickly becomes a self-referential argument I 
>  guess.

I can't speak for Fedora, but RHEL disables XFS in their kernel likely
because it is known to cause problems with 4K stacks.

>  Well, no. "oldconfig" works fine, and other than that, all failure modes 
>  I've heard about also in this thread are MD/LVM/XFS. This is extremely 
>  widely tested stuff in at least Fedora and RHEL.

Again don't assume that because Fedora and RHEL have 4K stacks means
that MD/LVM/XFS is widely tested.

Additionally I think I should point out that the problems pointed out so
far are not the only problem areas with 4K stacks.  There are out of
tree drivers to consider as well, and use cases like ndiswrapper.
