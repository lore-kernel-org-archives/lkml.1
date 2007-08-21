Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbXHUVCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbXHUVCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 17:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbXHUVBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 17:01:55 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:55246 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311AbXHUVBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 17:01:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BuSOF/+cnojk9s7htEXWIEjngL5l0MVCwvcoQ75mVIkWVtGlxTH/uJrFygg1DD742OcQeqr5Do0BySPstXqtcaPCweOScqnM0ElcqYcIAymqWa/pN9g72q8jOpd9PY2YvwIE2FpoOxoOqkf0B4o7GHgbYH1CYeEWdCy9iDqHJ10=
Message-ID: <5d6222a80708211401g6c88753cyd239006b5ed00aea@mail.gmail.com>
Date: Tue, 21 Aug 2007 18:01:51 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Segher Boessenkool" <segher@kernel.crashing.org>
Subject: Re: RFC: drop support for gcc < 4.0
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, "Jarek Poplawski" <jarkao2@o2.pl>,
       "Adrian Bunk" <bunk@kernel.org>, "Chris Wedgwood" <cw@f00f.org>,
       linux-arch@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <ea37408ece5ef8d2382ad551f74912eb@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070821132038.GA22254@ff.dom.local>
	 <20070821093103.3c097d4a.randy.dunlap@oracle.com>
	 <20070821173550.GC30705@stusta.de>
	 <20070821182505.GA20968@puku.stupidest.org>
	 <5d6222a80708211341s63f8c1eau922f018e66db49f4@mail.gmail.com>
	 <ea37408ece5ef8d2382ad551f74912eb@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/07, Segher Boessenkool <segher@kernel.crashing.org> wrote:
> > Last time I tried a mips build, it would fail the compile unless I was
> > using _exactly_ 3.4.4 (I didn't tried older versions, but did try
> > 3.4.6, for ex.).
>
> If 3.4.4 works where 3.4.6 doesn't, you should report this as a
> bug; either here, or to the GCC team (but please be aware that the
> 3.4 series isn't supported anymore), or to whoever built that
> compiler for you.

I didn't bothered reporting it here because linux-mips website quotes
explicitly  the dependency on 3.4.4. So at least, I imagined they are
aware of it. (And as you said, no point in reporting it to gcc...)

> > So I also think the 3.4 series will still have to be
> > around for a while.
>
> Huh?  3.4 doesn't work for you, so that's why it should stay
> a supported compiler?

3.4.4 does. anyway, by this phrase, I only meant: "Dropping support
for 3.4 series won't help in this case"

-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
