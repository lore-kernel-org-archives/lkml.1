Return-Path: <linux-kernel-owner+w=401wt.eu-S1759576AbYDZRzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576AbYDZRzj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 13:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYDZRzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 13:55:31 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:28097 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbYDZRz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 13:55:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R8V8RyBjZzN2BJPKfc/NTUgRxshAKDM7vm1vx3jf3EFn/iliXZnhgWw7N6T8lP8W8NPPaxzydXgigpvUj12w0FTnOUPb44D54gRKDeSi/SM2gQwrDlW6Nrci0iqxgQICf618ekUgddTxV7UhP6/3doVbNZfbc9rDScpNYxC1pPc=
Message-ID: <19f34abd0804261055u49d3951fn7e6d0a87e65254c2@mail.gmail.com>
Date: Sat, 26 Apr 2008 19:55:28 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [PATCH] headerdep: a tool for detecting inclusion cycles in header file
Cc: "Sam Ravnborg" <sam@ravnborg.org>, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       linux-kbuild@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080426172329.GO2252@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080426134554.GA20727@damson.getinternet.no>
	 <20080426164450.GK2252@cs181133002.pp.htv.fi>
	 <19f34abd0804260957i62db6929s2a4227a517f3c9a1@mail.gmail.com>
	 <20080426172329.GO2252@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/26/08, Adrian Bunk <bunk@kernel.org> wrote:
> On Sat, Apr 26, 2008 at 06:57:09PM +0200, Vegard Nossum wrote:
>  > On 4/26/08, Adrian Bunk <bunk@kernel.org> wrote:
>  > >  And you need cross compilers for all architectures since fiddling with
>  > >  #include's under include/ breaks code left and right that only compiled
>  > >  due to some implicit #include (and if it still works due to another
>  > >  implicit #include on x86 the latter might not be present on all
>  > >  architectures).
>  >
>  > Yep. I have been compiling cross-compilers myself. As a btw, I had
>  > already started some project to distribute binary cross-compilers
>  > http://folk.uio.no/vegardno/crosstool/ for the purpose of making
>  > cross-compiling easier to get started with. (It would be cool to have
>  > a complete suite of working cross-compilers in a single download.)
>
>
> "The source code for the binary files below can be downloaded from the
>   aforementioned project websites."
>
>  -> GPL violation

Thanks, corrected.

Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
