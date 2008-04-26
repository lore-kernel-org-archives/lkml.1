Return-Path: <linux-kernel-owner+w=401wt.eu-S1758554AbYDZPZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554AbYDZPZv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 11:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbYDZPZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 11:25:41 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:47993 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843AbYDZPZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 11:25:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wnADt1YaM/bktcfn375GKaHQKYWnfqbEcZvUk4YloZJ4/bsBrqnFJ6ebKjdcoiTswlhaRKAip8P0aOc/XjUoLn2+wRV6uLG07hHPeqe7z5eJt/gpw6M3E4NvwCr5NdEGnOJeMxKHP9nqlFBA17qGY8zqk++dql6dT0+TrgRzo7g=
Message-ID: <19f34abd0804260825p4690e4ncdd9a96398f8662d@mail.gmail.com>
Date: Sat, 26 Apr 2008 17:25:39 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [PATCH] headerdep: a tool for detecting inclusion cycles in header file
Cc: "Sam Ravnborg" <sam@ravnborg.org>, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       linux-kbuild@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080426150030.GH2252@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080426134554.GA20727@damson.getinternet.no>
	 <20080426150030.GH2252@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/26/08, Adrian Bunk <bunk@kernel.org> wrote:
> On Sat, Apr 26, 2008 at 03:45:54PM +0200, Vegard Nossum wrote:
>  > Hi Sam,
>  >
>  > Maybe something like this could be useful for cleaning up headers (and
>  > maintaining that cleanliness once it has been achieved). What do you think?
>  >
>  > (One thing which might or might not be good is that 'make headerdep' will
>  >  also compile using CC if they're not already compiled. If this should be
>  >  fixed, I think you'd know how to do it.)
>
>
> This way you only catch problems in the current kernel configuration.
>
>  The only problems are under include/, and you should be able to do this
>  by parsing all headers and without hooking into the build system.

This seems correct. Then a solution similar to 'make headers_check'
should be used.

Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
