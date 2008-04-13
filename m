Return-Path: <linux-kernel-owner+w=401wt.eu-S1752267AbYDMTen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbYDMTen (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 15:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYDMTeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 15:34:36 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:11368 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbYDMTef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 15:34:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qqgcxkcyVQEWXeNHQ5BD/HI/L/Yh0FmphzoRt3Gf+PI1ZmKwkZyZZQWSg3J0hF/HX5A7oUu89S7k4I5jGAeTTYJfy9taWtO0cvtzWjlwWUS3vzE7ly0YdTQAziXwbNfRAlW4uAyeLV3++exYFmPI8AvisporKgsKGWNgOVedCro=
Message-ID: <9a8748490804131234v26fefe9dp633fd0509b0fff6@mail.gmail.com>
Date: Sun, 13 Apr 2008 21:34:24 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] mfd/sm501.c: #if 0 unused functions
Cc: "Ben Dooks" <ben@simtec.co.uk>, "Vincent Sanders" <vince@simtec.co.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080413192420.GC21204@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080413181531.GD2182@cs181133002.pp.htv.fi>
	 <9a8748490804131155g3df93ba7s9c2131a957391ee3@mail.gmail.com>
	 <20080413190326.GB21204@cs181133002.pp.htv.fi>
	 <9a8748490804131208o220cd763k33b74d547911a8f0@mail.gmail.com>
	 <20080413192420.GC21204@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/04/2008, Adrian Bunk <bunk@kernel.org> wrote:
> On Sun, Apr 13, 2008 at 09:08:31PM +0200, Jesper Juhl wrote:
>  > On 13/04/2008, Adrian Bunk <bunk@kernel.org> wrote:
>  > > On Sun, Apr 13, 2008 at 08:55:21PM +0200, Jesper Juhl wrote:
>  > >  > On 13/04/2008, Adrian Bunk <bunk@kernel.org> wrote:
>  > >  > > This patch #if 0's the following unused functions:
>  > >  > >  - sm501_find_clock()
>  > >  > >  - sm501_gpio_get()
>  > >  > >  - sm501_gpio_set()
>  > >  > >
>  > >  >
>  > >  > Hi Adrian,
>  > >  >
>  > >  > I know we've discussed this before, but I have to comment on this once more.
>  > >  >
>  > >  > Why is it that you seem to prefer adding '#if 0' around blocks of
>  > >  > unused code instead of removing it outright?
>  > >
>  > > >...
>  > >
>  > >  When I removed unused code outright some people complained that they
>  > >  plan to use it tomorrow or in the next millenium or whenever.
>  > >
>  > >  When I #if 0 it other people complain that I should remove it outright.
>  > >
>  > >  So whatever I do, there's always someone complaining.  ;-)
>  > >
>  > >  In this case the code looks as if it might get used at some point in the
>  > >  future.
>  > >
>  > >  But if a maintainer tells me to resend a patch with the code removed
>  > >  instead of #if 0'ed I'm always glad to do this.
>  > >
>  > But, you are completely ignoring the case of "the code is unused, but
>  > will probably be used soon, so I'll just leave it alone and avoid the
>  > churn".  Why? What's the point of commenting it out now and then
>  > enabling it again in a month or two - isn't that just pointless churn?
>
> >...
>
>  It's unused since more than one year, so chances are it won't get used
>  in a month or two.
>
Then I really don't see why you chose the '#if 0' option. In that case
it would seem to me that either "leave it alone, don't submit a patch"
or "submit a patch to remove it outright" would both be more
preferable options.

>  As I said, if a maintainer wants me to remove it outright I'll be glad
>  to do so.
>
I don't doubt that.

>  And as I said, no matter whatever I do, there's always someone
>  complaining...
>
Please don't see my comments as complaints. They are not intended as
such. I'm merely currious why we keep adding all these '#if 0's since
I don't see the point and I can just see them piling up into some huge
janitorial mountain from hell to be tackled some time in the future by
whomever is masochistic enough to try ;-)

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
