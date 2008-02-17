Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbYBQQex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbYBQQex (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 11:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbYBQQeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 11:34:44 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:53047 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256AbYBQQen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 11:34:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Rhhqei1SBEfl1P97wxFeKJMtu4KVWZfsPM7uJh/Nn9ctK6NqNO1eEizKx2B7SwQUixR2Vx7jwLKTHOiHD6o/OP9+js+EqAy2QFd2zG5ItP9d6QR3SlPH4wvqiZHyxjFWZVwiEUvXLir7djmFKHf8xByg9UdtP2MKuqf1B+sIhTo=
Message-ID: <e367bd3e0802170834j26958809h2761d4647fe46d6a@mail.gmail.com>
Date: Sun, 17 Feb 2008 11:34:42 -0500
From: "Nicholas Marquez" <nicholas.marquez@gatech.edu>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: [PATCH] More accessible usage of custom flags
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <20080217103738.GB6596@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e367bd3e0802161852v1265f101h86326b16362dd860@mail.gmail.com>
	 <20080217103738.GB6596@martell.zuzino.mipt.ru>
X-Google-Sender-Auth: ae34437f0e5bc84d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 17, 2008 5:37 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Sat, Feb 16, 2008 at 09:52:51PM -0500, Nicholas Marquez wrote:
> > I submitted this patch to the zen-sources Gentoo community and got
> > much praise and has promptly been included.  This kind of thing have
> > very likely already been done in other patchsets, but I haven't seen
> > it around,
>
> Probably it wasn't done by other patchsets. ;-)
>
> > so I've gone ahead and made one.  The idea is that one can
> > enable -Os and various other options transparently through standard
> > kernel configuration, so why bar the builder from any other options to
> > pass on to gcc (et al)?
>
> Examples, please. Which compiler flags do you want to add to your .config?
> Speaking of -Os, it's CONFIG_CC_OPTIMIZE_FOR_SIZE .

For example: DFORTIFY_SOURCE=2 or ftree-ch, because it's not enabled
by Os, but does indeed help often, especially in the case of various
kernel codepaths.
As to CONFIG_CC_OPTIMIZE_FOR_SIZE, I realize.  "-Os" is just easier to
type and I assume that a kernel dev list would map the correct config
option.  ;)

>
> > One can indeed add one's own flags in the
> > Makefile, but this method is a good deal friendlier.  Granted, this
> > could be misused by ricers and idiots, but they'll get themselves into
> > that mess all of their own fault and we'll all go on our merry ways.
>
> No, they will come here and report bugs they created themselves. And
> there will be a policy: "too long CONFIG_CUSTOM_CFLAGS -- go away" and
> so on.

My point exactly.  Enabling experimental or broken options is already
ignored pretty well, so how hard is it to just create such a policy
and go about shooting down people who've messed up?  In all fairness,
most people on the mailing list are terse and, shall we say,
aggressive.  I don't really see there being much of a problem with a
few extra faulty bug reports.  I feel that the good done would
outweigh the slight overhead of a few idiots.

>
> > It just seems that much use could be made out of this, both in terms
> > of (sane) optimizations
>
> Sane optimizations should be added to main Makefile.
>
> > and easier access to enhanced debugging
> > opportunities.
>
> Which ones exactly?
>
> > I see that people who build a Linux kernel are largely of two types:
> > ~the ones that understand and know enough that they could, with some
> > nudging and learning, become bonafide kernel devs and
> > ~the ones that understand it to some very basic degree and can get
> > through configuring it without too much trouble (though with limited
> > understanding)
> > I believe one of the very simple things that can be addressed is to
> > make the kernel more "accessible" without harming its integrity or
> > functionality.  This involves trying to fill the gap between those two
> > types of people, allowing there to be more understanding,
> > configuration, and (down the line) development opportunities within
> > the kernel to better ease these people into learning enough to begin
> > contributing back.
>
> > More developers can only be a Good Thing (tm).
>
> In general, wrong.
>

Erm... what are you responding to?  I don't know what that "wrong"
refers to.  Especially considering that the paragraph you're
referencing is an opinion and personal thought.
