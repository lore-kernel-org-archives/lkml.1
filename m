Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbXFOGsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbXFOGsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 02:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbXFOGrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 02:47:47 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:57724 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbXFOGrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 02:47:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=px7k8vczWXDE5Q1IT9J627XADbEBaaxdW+HlHDVeMaGVw4vYkAz9Vr+hieRoqtftkF4qq0rYVYvaqozkSU0rkYhAim8aPzDoqXPh2ofasfALwt01y+N2hEMb+lFZJcvyqjVe9ZHIwvEiEiwtv0YVj0Gev8ewGcfJWcM7H6fUCeo=
Message-ID: <f24d23310706142347r1f02b551u6aa9a5eb33072193@mail.gmail.com>
Date: Fri, 15 Jun 2007 12:17:44 +0530
From: "debian developer" <debiandev@gmail.com>
To: "dave young" <hidave.darkstar@gmail.com>
Subject: Re: coding style
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>, "Willy Tarreau" <w@1wt.eu>,
       "Cyrill Gorcunov" <gorcunov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>
In-Reply-To: <a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070614184836.GA6520@cvg> <20070615045111.GU943@1wt.eu>
	 <46721F18.8090303@intel.com>
	 <a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/15/07, dave young <hidave.darkstar@gmail.com> wrote:
> Hi,
> The Documentation/CodingStyle says:
>
> Outside of comments, documentation and except in Kconfig, spaces are never
> used for indentation, and the above example is deliberately broken.
>
> Regards
> dave
>
> 2007/6/15, Kok, Auke <auke-jan.h.kok@intel.com>:
> > Willy Tarreau wrote:
> > > On Thu, Jun 14, 2007 at 10:48:36PM +0400, Cyrill Gorcunov wrote:
> > >> Hi to all,
> > >>
> > >> a simple question the answer to witch I didn't find in CodingStyle.
> > >> Look for a code snip:
> > >>
> > >>      err = foo(arg_a, arg_b, arg_c,
> > >>              arg_d);
> > >>
> > >> the second line contains 'd' arg aligned with tabs only
> > >> but it could be rewritten with more elegant style (by adding
> > >> a few spaces) like this
> > >>
> > >>      err = foo(arg_a, arg_b, arg_c,
> > >>                arg_d);
> > >>
> > >> so which one is preferred for the kernel?
> > >
> > > There is no "preferred", just one good and one bad :-)
> > >
> > > Ideally, you should use tabs only for indentation, and spaces only for
> > > alignment. Keep in mind that there are people using different tab sizes
> > > and that your tabs should not make it harder for them to read your code.
> > > In your example above, you should use tabs from left up to "err", then
> > > spaces to go from "err" to "arg_d".
> > >
> > > However, we know that some editors such as emacs are stupid in this regard,
> > > because they fill with tabs then complete with spaces, so it's not always
> > > easy.
> >
> > the current "checkpatch.pl" script rejects this notion and requires that you use
> > tabs whenever you can (you can still align code within the length of one tab).
> >
> > Since in the example part (2) above there are 9 spaces needed to go from err to
> > arg_d, it complains if you had used 9 spaces here. It only allows you to use
> > tabs + n spaces (where n < 8)
> >
> > I personally prefer spaces, but the checkpatch.pl script does not agree, much to
> > my dismay :(
> >
> >
> > Auke
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
And *Please* do not top-post!
I know gmail directly goes to the top while replying, but think of
other mail clients out there.
