Return-Path: <linux-kernel-owner+w=401wt.eu-S1757029AbXFURUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029AbXFURUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbXFURUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:20:35 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:12169 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbXFURUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:20:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pDhCbD1sshpLl6cUuuo7dqNv5uBYtA8TLW72fkrhJ3kTKhFHXFrr5idfOzZ3tudEGL+Z120xe09VnUN5wyThFp0gNtCSzEwlQdA1Gloa/9STt8rvLq+4ydm/fmGT0Fh05+p3Gls3CZGEMfQ1RaCNndS2yRm2uRe2ZUXAisRJJZc=
Message-ID: <9a8748490706211020g1d96bd2anc0caa0aa2fdc5045@mail.gmail.com>
Date: Thu, 21 Jun 2007 19:20:33 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH] bracing the loop in kernel/softirq.c
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070621134933.GA6589@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070620175737.GA6523@cvg>
	 <9a8748490706201401m36b1e917g5a600951d48e4cf8@mail.gmail.com>
	 <20070621134933.GA6589@cvg>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/06/07, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> [Jesper Juhl - Wed, Jun 20, 2007 at 11:01:44PM +0200]
> | From: Jesper Juhl <jesper.juhl@gmail.com>
> | To: Cyrill Gorcunov <gorcunov@gmail.com>
> | Cc: LKML <linux-kernel@vger.kernel.org>
> | Subject: Re: [PATCH] bracing the loop in kernel/softirq.c
> | Date: Wed, 20 Jun 2007 23:01:44 +0200
> |
> > On 20/06/07, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> >> This trivial patch adds braces over a one-line
> >> loop. That makes code...well... little bit
> >> convenient for (possible) further modifications.
> >>
> > That's generally not done.
> >
> > It's even in Documentation/CodingStyle :
> >
> > "
> > Do not unnecessarily use braces where a single statement will do.
> >
> > if (condition)
> >        action();
> > "
>
> look, the CodingStyle is absolutely right BUT:
>
>         - dropping the braces are good solution for 'if' statement indeed
>         - dropping the braces are _not_ good for 'do' - 'while' loop 'case
>           it fails on further loop modifications. Moreover adding these braces
>           we don't change amount of lines in code! So why souldn't we? I don't
>           see any reason not to do.
>

Personally, in this case, I don't care. I'm simply telling you that
usually that's not a patch that would get accepted, that's all.  But
it's all up to the maintainer of that area of the kernel (whom you
probably want to at least Cc in addition to just LKML).   :-)

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
