Return-Path: <linux-kernel-owner+w=401wt.eu-S1759636AbYDMT4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636AbYDMT4Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 15:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757208AbYDMTxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 15:53:42 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:38460 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759911AbYDMTxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 15:53:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UAJZRR3KlHs/nxTz1ciCE3gCi9AOkQfIblWhFqpZ3SZL8fkd0Rpo8c+rc9Jzlk4tX66HFj9USM5P8OpfymibEPW5/JxSXgXs4QUbZV7qEzy5S1QxKvm4/HQHFlLNLjmh18PWNUTlE5lzyGjRAF3jXpx3qpq97Kcyc2S8DP8TMBw=
Message-ID: <9a8748490804131253qcd8d61et945b830d12669730@mail.gmail.com>
Date: Sun, 13 Apr 2008 21:53:29 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] mfd/sm501.c: #if 0 unused functions
Cc: "Ben Dooks" <ben@simtec.co.uk>, "Vincent Sanders" <vince@simtec.co.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080413194755.GB13920@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080413181531.GD2182@cs181133002.pp.htv.fi>
	 <9a8748490804131155g3df93ba7s9c2131a957391ee3@mail.gmail.com>
	 <20080413190326.GB21204@cs181133002.pp.htv.fi>
	 <9a8748490804131208o220cd763k33b74d547911a8f0@mail.gmail.com>
	 <20080413192420.GC21204@cs181133002.pp.htv.fi>
	 <9a8748490804131234v26fefe9dp633fd0509b0fff6@mail.gmail.com>
	 <20080413194755.GB13920@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/04/2008, Adrian Bunk <bunk@kernel.org> wrote:
> On Sun, Apr 13, 2008 at 09:34:24PM +0200, Jesper Juhl wrote:
>  >...
>  > Please don't see my comments as complaints. They are not intended as
>  > such. I'm merely currious why we keep adding all these '#if 0's since
>  > I don't see the point and I can just see them piling up into some huge
>  > janitorial mountain from hell to be tackled some time in the future by
>  > whomever is masochistic enough to try ;-)
>
>
> The main advantage of the #if 0 solution is that it not only stops
>  bloating the kernel image, but in the frequent "I might need it some day"
>  case I can simply say "no problem with my patch - just remove the #if 0".
>
Heh, and in the mean time I'm tempted to submit a huge patch removing
all code within
  #if 0
  #endif
outright.
Just to get rid of all the useless code we are carrying around from
release to release.
Those 2168 '#if 0' blocks amount to quite a lot of
code^d^d^d^dcomments and most of it is just useless...  But, before I
attempt that I need to go and buy new flame proof underwear.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
