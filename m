Return-Path: <linux-kernel-owner+w=401wt.eu-S1759838AbXGBOWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759838AbXGBOWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 10:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbXGBOWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 10:22:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:52366 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717AbXGBOWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 10:22:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y2OF42zUt5xrStI/hv1cuq5YzF+/YejO7k8jxM6KqPXyd/o/ZhIraY9u7h2CNUIRbEgHvto9qFDu9H/eFUjQ4oyd+69FICjPsoMTPNPUZTG0HjW5WsbRKiRMzeBfwuuxTu9VvgUipW/By+Z2+Cs5lDFFJAP21rkrRAHQaVy/eVI=
Message-ID: <81b0412b0707020722q25e8eb41t456e7316fe4a7b40@mail.gmail.com>
Date: Mon, 2 Jul 2007 16:22:07 +0200
From: "Alex Riesen" <raa.lkml@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: why does git perpetually complain about include/asm-blackfin/macros.h?
Cc: "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Git Mailing List" <git@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <4689073D.1020802@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0707020800010.1972@localhost.localdomain>
	 <4688EF9B.8020405@garzik.org>
	 <9a8748490707020658t5e6542ag6edb435dbc4499ab@mail.gmail.com>
	 <4689073D.1020802@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/2/07, Jeff Garzik <jeff@garzik.org> wrote:
> Jesper Juhl wrote:
> > On 02/07/07, Jeff Garzik <jeff@garzik.org> wrote:
> >> Robert P. J. Day wrote:
> >> >   for the umpteenth time, after doing a pull, i see this:
> >> >
> >> > $ git diff
> >> > diff --git a/include/asm-blackfin/macros.h
> >> b/include/asm-blackfin/macros.h
> >> > deleted file mode 100644
> >> > index e69de29..0000000
> >> > $
> >>
> >> I have the same problem.  git 1.5.0.6 on Fedora Core 5 or 6.
> >>
> >> I even tried a completely fresh clone, but the problem still appears.
> >>
> > I've seen that as well, but in my case doing a
> > $ git reset --hard master
> > fixed it.
>
> Sure.  git checkout -f fixes it too.
>
> But then it reappears the every time I switch branches.
>

Do some of your branches miss the commit by which it was removed?
(It was removed in df30b1171714bbf0e55ffe02138be4b8447e4235)
Than it will reappear every time you switch to a branch which still has
the file.

It is somewhat unclear what "reappear" means, though: do you mean
in your working directory (that's what I explained above) or do you
mean: on the commit pointed by HEAD?

In that second case I can only suspect that all your branches point
at the same commit, which is just before the one the file was removed
in...
