Return-Path: <linux-kernel-owner+w=401wt.eu-S1756250AbXLBS7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbXLBS7u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 13:59:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbXLBS7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 13:59:42 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3458 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751472AbXLBS7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 13:59:42 -0500
Date: Sun, 2 Dec 2007 18:37:25 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Chris Snook <csnook@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Avoid overflows in kernel/time.c
Message-ID: <20071202183724.GD4721@ucw.cz>
References: <200711300019.lAU0Jpbr003807@tazenda.hos.anvin.org> <474F6E7A.3090705@redhat.com> <474F7DC4.8000607@zytor.com> <20071129194027.10046988@laptopd505.fenrus.org> <474F8984.4010602@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474F8984.4010602@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2007-11-29 19:54:44, H. Peter Anvin wrote:
> Arjan van de Ven wrote:
> >>
> >>Anyway, I don't think compiling bc is hard on anything 
> >>which has a C compiler.
> >
> >alternative is to just also ship the precomputed values 
> >;-)
> >
> 
> Oh, come on... it's not like bc is some obscure thing.  
> It's a POSIX utility.

I think shiping precomputed values makes sense here. They are not
going to change often, right?
						Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
