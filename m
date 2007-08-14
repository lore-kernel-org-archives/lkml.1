Return-Path: <linux-kernel-owner+w=401wt.eu-S1760542AbXHNLob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760542AbXHNLob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 07:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757781AbXHNLna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 07:43:30 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56053 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754477AbXHNLn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 07:43:28 -0400
Date: Tue, 14 Aug 2007 09:11:48 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       linux-arch@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH] Add ability to print calltraces tighter on i386
Message-ID: <20070814071148.GA2905@elf.ucw.cz>
References: <46B9D08F.8080402@openvz.org> <p73zm12qc8a.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73zm12qc8a.fsf@bingen.suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > E.g. OOPSes of 50 lines occupy ~20 with this patch.
> > 
> > This is an example of how it will look for i386, but if this
> > will be found useful, I will make the patch for other arched
> > I can test it on (at least x86_64, ia64).
> 
> Just use a higher resolution with vga=... 
> I have yet to see an oops that doesn't fit on 80x50

vga= does not work properly in some setups I'd like to debug, like
kexec.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
