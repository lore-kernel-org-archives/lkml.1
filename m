Return-Path: <linux-kernel-owner+w=401wt.eu-S933790AbXGUVfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933790AbXGUVfQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 17:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761519AbXGUVfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 17:35:01 -0400
Received: from qb-out-0506.google.com ([72.14.204.230]:59536 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758280AbXGUVfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 17:35:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ovXnN25EUXR0DdLMLMyug31aSy1L2dG5ixEvluxm9FL/liKtJAQQCR8DUwvrv8d8+sRpaTVzbtJKmD65s0VwnPqadHAkr8edvcBHTYaX3Ncq7EFSUHT6inSyvHEjyOFyyJBvoIWgIzjOgIu96/SW1vr/h8RkosNC2nRSpdDFsb0=
Message-ID: <9a8748490707211434j27b33581wb570849a86943a61@mail.gmail.com>
Date: Sat, 21 Jul 2007 23:34:53 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Jens Axboe" <axboe@kernel.dk>, "Andrew Morton" <akpm@osdl.org>,
       lkml <linux-kernel@vger.kernel.org>, drbd-user@linbit.com
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
In-Reply-To: <20070721203819.GA10706@mail.linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070721203819.GA10706@mail.linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/07/07, Lars Ellenberg <lars@linbit.com> wrote:
>
>         DRBD wants to go mainline.
>         please have a look at the "for-linus" branch of
>         git://git.drbd.org/home/git/linux-drbd.git.
>

I just fetched yourt branch and had a (very) quick look.

Some comments.

Try running your patches through scripts/checkpatch.pl - it shows a
lot of style problems. Fixing those up would probably be a good step
towards mainline.  Remember, checkpatch.pl is not the law - in some
situations what it complains about can be totally valid, but usually
what it highlights is stuff that it is prefered to clean up (I'd say
especially now prior to inclusion so we don't have to do it post
inclusion).

A few of your files suffer from trailing whitespace at the end of lines.

It's interresting to build your code with -W. It shows up quite a few
signed vs unsigned comparisons, unused parameters, expressions that
are always false, etc.  Although I doubt anyone is going to complain
too loudly about stuff that only shows up with "-W", cleaning it up
can't hurt.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
