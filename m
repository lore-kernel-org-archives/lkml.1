Return-Path: <linux-kernel-owner+w=401wt.eu-S964815AbXCSWZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964815AbXCSWZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 18:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964944AbXCSWZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 18:25:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:13206 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964815AbXCSWZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 18:25:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HmCe5X8wwdyrH3Sn43sIHokERIb7r/VY2fToNMOYqqIllvQwQAl4LkCxEnT0sizZN78eKSVui+nJrQpZ+LCCa0Ccj/nOTzu7BLQrkc5PMN7OhuRVegcn1OxkzhgO7ErhzaGWPEeaIoyHD2Kowo6284HEiKwjkiJmpggemuLa/Y8=
Message-ID: <9a8748490703191525o1e80b3e5gdd088726df7715ec@mail.gmail.com>
Date: Mon, 19 Mar 2007 23:25:08 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: [PATCH][1/5][resend] floppy.c: Initial (partial) CodingStyle cleanup
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Andi Kleen" <ak@suse.de>,
       "Trent Waddington" <trent.waddington@gmail.com>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20070319202008.GY752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703191610.13940.jesper.juhl@gmail.com>
	 <20070319083159.0744cf5e.randy.dunlap@oracle.com>
	 <200703191918.39277.jesper.juhl@gmail.com>
	 <20070319202008.GY752@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/03/07, Adrian Bunk <bunk@stusta.de> wrote:
> On Mon, Mar 19, 2007 at 07:18:38PM +0100, Jesper Juhl wrote:
> >...
> > The second reason is that indenting two tabs seems to make the most sense for
> > a few reasons;
> >       a) not indenting at all is ugly, plain and simple.
> >               void function(int a, int b,
> >               int c, int d, int e)
> >               {
> >                       int foo;
> >                       int bar;
> >               ...
> >               }
> >       b) indenting only one tab stop puts parameters at the same indent level as
> >          variables in the function which is potentially confusing (at least IMHO).
> >               void function(int a, int b,
> >                       int c, int d, int e)
> >               {
> >                       int foo;
> >                       int bar;
> >               ...
> >               }
> >       c) Indenting so that all parameter lines start at the opening paranthesis
> >          rarely matches up with tabs so you have to use varying amounts of spaces
> >          depending on how long the function name is. Not a good solution IMHO.
> >               void function(int a, int b,
> >                                    int c, int d, int e)
> >...
>
> Your example is wrong, it's:
>
>                void function(int a, int b,
>                              int c, int d, int e)
>
Hmm, thanks, when I wrote it in kmail it looked right. two tabs and
then spaces to make it line up with the starting '('.

>
> This is the most common convention in the kernel - and except for
> extremely long function names it's the one with the best readability.
>
It may be the most common, but I don't agree that it has the best
readability - but I guess that's very much a subjective thing.

> Yes, it's a problem with extremely long function names, but they are
> rare in the kernel.
>
> And the "varying amounts of spaces" should be handled automatically by
> your editor.
>

My editor may handle it initially when writing the code, but then it
gets changed and not updated or spaces and tabs end up getting mixed -
like "<tab><tab><space><tab><space>" or something else - it easily
turns into a mess.

Simply using two tabs makes it easy to see that it's not variables in
the function body and is an easy and simple convention to follow (and
IMHO also very readable).

But I guess we'll have to agree to disagree on this.
In any case, thank you for your input.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
