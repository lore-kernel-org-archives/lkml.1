Return-Path: <linux-kernel-owner+w=401wt.eu-S964780AbXBYKmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964780AbXBYKmZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 05:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964783AbXBYKmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 05:42:25 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:40265 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964780AbXBYKmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 05:42:23 -0500
Date: Sun, 25 Feb 2007 11:42:12 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: davids@webmaster.com, v j <vj.linux@gmail.com>, trent.waddington@gmail.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
Subject: Re: GPL vs non-GPL device drivers
Message-ID: <20070225104211.GB2045@elf.ucw.cz>
References: <3d57814d0702191458l1021caeyaefd7775398c5f2a@mail.gmail.com> <MDEHLPKNGKAHNMBLJOLKIEFNBLAC.davids@webmaster.com> <f2b55d220702211408r7954d5dar2c59e1e679316811@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2b55d220702211408r7954d5dar2c59e1e679316811@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Actually, it's quite clear under US law what a derivative work is and
> what rights you need to distribute it, and equally clear that
> compiling code does not make a "translation" in a copyright sense.
> Read Micro Star v. Formgen -- it's good law and it's funny and
> readable.
> 
> I've drafted summaries from a couple of different angles since VJ
> requested a "translation into English", and I think this is the most
> coherent (and least foaming-at-the-mouth) I've crafted yet.  It was
> written as an answer to a private query to this effect:  "I write a
> POP server and release it under the GPL.  The Evil Linker adds some
> hooks to my code, calls those hooks (along some of the existing ones)
> from his newly developed program, and only provides recipients of the
> binaries with source code for the modified POP server.  His code
> depends on, and only works with, this modified version of my POP
> server.  Doesn't he have to GPL his whole product, because he's
> combined his work with mine?"
> 
> This is a fundamental misconception.  A <<product>> is not a "work

Ok, but this is not realistic. I agree that if Evil Linker only adds
two hooks "void pop_server_starting(), void pop_server_stopping()", he
can get away with that.

But... how does situation change when Evil Linker does #include
<pop3/gpl_header_file_with_some_inline_functions.h> from his
binary-only part?

I believe situation in this case changes a lot... And that's what
embedded people are doing; I do not think they are creating their own
headers or their own inline functions where headers contain them.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
