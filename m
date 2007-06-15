Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbXFOGjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbXFOGjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 02:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbXFOGi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 02:38:56 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:13094 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbXFOGiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 02:38:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OjDdHMD00kHC0hR2yjr2hE4n7cc7rtG2Vnb7aBE3gwmExHV5EuaneoyVT8/xQcW5ITXAGiZ2VaGxDDRb2V0b7+CGC6ZJcVpqCpoOgxPnf3Hemewr8XOsggIry6haLgpYfPKY7VUVQnYZ+9wy7uB4wlFVtjkyEh0rHvUdoJ2ylM0=
Message-ID: <a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com>
Date: Fri, 15 Jun 2007 06:38:54 +0000
From: "dave young" <hidave.darkstar@gmail.com>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Subject: Re: coding style
Cc: "Willy Tarreau" <w@1wt.eu>, "Cyrill Gorcunov" <gorcunov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>
In-Reply-To: <46721F18.8090303@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070614184836.GA6520@cvg> <20070615045111.GU943@1wt.eu>
	 <46721F18.8090303@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
The Documentation/CodingStyle says:

Outside of comments, documentation and except in Kconfig, spaces are never
used for indentation, and the above example is deliberately broken.

Regards
dave

2007/6/15, Kok, Auke <auke-jan.h.kok@intel.com>:
> Willy Tarreau wrote:
> > On Thu, Jun 14, 2007 at 10:48:36PM +0400, Cyrill Gorcunov wrote:
> >> Hi to all,
> >>
> >> a simple question the answer to witch I didn't find in CodingStyle.
> >> Look for a code snip:
> >>
> >>      err = foo(arg_a, arg_b, arg_c,
> >>              arg_d);
> >>
> >> the second line contains 'd' arg aligned with tabs only
> >> but it could be rewritten with more elegant style (by adding
> >> a few spaces) like this
> >>
> >>      err = foo(arg_a, arg_b, arg_c,
> >>                arg_d);
> >>
> >> so which one is preferred for the kernel?
> >
> > There is no "preferred", just one good and one bad :-)
> >
> > Ideally, you should use tabs only for indentation, and spaces only for
> > alignment. Keep in mind that there are people using different tab sizes
> > and that your tabs should not make it harder for them to read your code.
> > In your example above, you should use tabs from left up to "err", then
> > spaces to go from "err" to "arg_d".
> >
> > However, we know that some editors such as emacs are stupid in this regard,
> > because they fill with tabs then complete with spaces, so it's not always
> > easy.
>
> the current "checkpatch.pl" script rejects this notion and requires that you use
> tabs whenever you can (you can still align code within the length of one tab).
>
> Since in the example part (2) above there are 9 spaces needed to go from err to
> arg_d, it complains if you had used 9 spaces here. It only allows you to use
> tabs + n spaces (where n < 8)
>
> I personally prefer spaces, but the checkpatch.pl script does not agree, much to
> my dismay :(
>
>
> Auke
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
