Return-Path: <linux-kernel-owner+w=401wt.eu-S1763973AbXG0ARv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763973AbXG0ARv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 20:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbXG0ARn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 20:17:43 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:36617 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019AbXG0ARm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 20:17:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=d6XfQqDFUH+HWUdMQDctnU7IYAlqA4n8n8ZURMwLc1gdK5u+fdN8NnCN+r90HDwaCxYqEEcrVR80UFfhu9ad1HCWjHpr6aF9jG6Ik39KfeYRyfTMqaPYCkrrVhStC1LBoUlU4eCTPhDVrtBs47zXl+SzQ82XFDtWn55TzhGn3QI=
Message-ID: <9a8748490707261717i247e7cbcgbf01ee9c69d21e3@mail.gmail.com>
Date: Fri, 27 Jul 2007 02:17:40 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [PATCH] MAINTAINERS: use relevant mailing lists
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
In-Reply-To: <20070726170857.dbb42674.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070726170857.dbb42674.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/07/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Add text on using relevant mailing lists.
>

I'd add a little bit to that - see below

> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  MAINTAINERS |   13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
>
> --- linux-2623-rc1g2.orig/MAINTAINERS
> +++ linux-2623-rc1g2/MAINTAINERS
> @@ -23,15 +23,18 @@ trivial patch so apply some common sense
>  4.     When you are happy with a change make it generally available for
>         testing and await feedback.
>
> -5.     Make a patch available to the relevant maintainer in the list. Use
> -       'diff -u' to make the patch easy to merge. Be prepared to get your
> -       changes sent back with seemingly silly requests about formatting
> -       and variable names.  These aren't as silly as they seem. One
> -       job the maintainers (and especially Linus) do is to keep things
> +5.     Make a patch available to the relevant maintainer(s) and mailing
> +       list(s). Use 'diff -u' to make the patch easy to merge. Be prepared
> +       to get your changes sent back with seemingly silly requests about
> +       formatting and variable names.  These aren't as silly as they seem.
> +       One job the maintainers (and especially Linus) do is to keep things
>         looking the same. Sometimes this means that the clever hack in
>         your driver to get around a problem actually needs to become a
>         generalized kernel feature ready for next time.
>
> +       Use the relevant mailing list(s) -- don't just send everything to
> +       lkml (linux-kernel@vger.kernel.org).

 +       Always including lkml in addition to more specific lists is usually OK.

> +
>         PLEASE check your patch with the automated style checker
>         (scripts/checkpatch.pl) to catch trival style violations.
>         See Documentation/CodingStyle for guidance here.



-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
