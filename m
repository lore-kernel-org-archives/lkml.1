Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbXH1Rmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbXH1Rmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 13:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbXH1Rmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 13:42:35 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:29176 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbXH1Rmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 13:42:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EEpXWSLOGciey4z1tWDBnX4fnqxN8sDEj9OEHHEZlfDOPv/qlSIb5WBq3Fph4f5NKX8DrVSIgpqV/TzZLBeqpAW+s4eYR1ZLEZlvo6aZup3r5Ha3kocjrr2cpUqC9WR8o1GikFlBZGxpo87HGEAuf2Goy52yUX5hzwjl0WALUxE=
Message-ID: <8bd0f97a0708281042w6d7e57abm179337b01c254afb@mail.gmail.com>
Date: Tue, 28 Aug 2007 13:42:32 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [-mm patch] make types.h usable for non-gcc C parsers
Cc: "Adrian Bunk" <bunk@stusta.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Gabriel C" <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org,
       "Olaf Hering" <olh@suse.de>, netdev@vger.kernel.org
In-Reply-To: <20070828170604.GA31284@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	 <46CC3B27.10604@googlemail.com> <20070827212743.GN4121@stusta.de>
	 <20070828003704.deed71ae.akpm@linux-foundation.org>
	 <20070828144248.GR26410@stusta.de>
	 <20070828170604.GA31284@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/28/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> > > But I'd like a better description, please.  Which "non-gcc parser" are we
> > > talking about here?  Something under ./scripts/.  Well, please identify it,
> > > and describe what the problem is, and how the proposed patch will address
> > > it.
> > >...
> >
> > It's about parsers like the Sun C compiler and the C parser shipped
> > with genksyms.
>
> So it is about two bugs.
> 1) kbuild (genksyms) fails to generate CRC for some symbols
> 2) allow userspace to parse the header
>
> As for 2 we already use sed to remove a lot of stuff in our headers
> so why do we use another approach here?

the sed removes things permanently and is designed for scrubbing
things that are kernel-only ... in this case, these typedefs are not
kernel only, but exposed conditionally when the compiler/standard
allows for it
-mike
