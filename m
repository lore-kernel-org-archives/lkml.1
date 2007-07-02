Return-Path: <linux-kernel-owner+w=401wt.eu-S1758847AbXGBN6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847AbXGBN6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 09:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbXGBN6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 09:58:41 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:12438 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbXGBN6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 09:58:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OH+DDEdA4xbijpViw/U67Bd6XpUH/o31Zqm2BaLitegCCIGtTe8t9antUyCisK6GVOh3Y+7bNghjg3gmqg7ivrd+uUbW9eXV5cZT3bM8vMW3/GgxAlGpmprZRqe1X8R04ti+LC0o8cycFW4NYWefI8ManeZ+tgUWoZFtnGPpQ2w=
Message-ID: <9a8748490707020658t5e6542ag6edb435dbc4499ab@mail.gmail.com>
Date: Mon, 2 Jul 2007 15:58:39 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: why does git perpetually complain about include/asm-blackfin/macros.h?
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Git Mailing List" <git@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <4688EF9B.8020405@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0707020800010.1972@localhost.localdomain>
	 <4688EF9B.8020405@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/07, Jeff Garzik <jeff@garzik.org> wrote:
> Robert P. J. Day wrote:
> >   for the umpteenth time, after doing a pull, i see this:
> >
> > $ git diff
> > diff --git a/include/asm-blackfin/macros.h b/include/asm-blackfin/macros.h
> > deleted file mode 100644
> > index e69de29..0000000
> > $
>
> I have the same problem.  git 1.5.0.6 on Fedora Core 5 or 6.
>
> I even tried a completely fresh clone, but the problem still appears.
>
I've seen that as well, but in my case doing a
$ git reset --hard master
fixed it.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
