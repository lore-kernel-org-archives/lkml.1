Return-Path: <linux-kernel-owner+w=401wt.eu-S965356AbXC0Wdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965356AbXC0Wdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 18:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965360AbXC0Wdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 18:33:35 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50497 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965356AbXC0Wdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 18:33:33 -0400
Date: Wed, 28 Mar 2007 00:33:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] add file position info to proc
Message-ID: <20070327223324.GB6752@elf.ucw.cz>
References: <E1HVELJ-0006ed-00@dorka.pomaz.szeredi.hu> <20070327212419.GA5817@ucw.cz> <20070327143629.9c8953db.akpm@linux-foundation.org> <E1HWJRv-00052q-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HWJRv-00052q-00@dorka.pomaz.szeredi.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > For each fd the information is provided in the following format:
> > > > 
> > > > pos:	1234
> > > > flags:	0100002
> > > 
> > > Octal? Maybe we should use more traditional hex here?
> 
> It's octal in <fcntl.h>, so it's easier for a human to read.
> 
> > Good point.  The O_foo flags are per-arch, so this field has the potential
> > to be subtly different on different architectures, which is unpleasing.
> > 
> > > Or even list flags by name?
> > 
> > urg.  Simple enough to do (lookup table, please).  But is it worth it? 
> > Perhaps just remove that field?
> 
> I wouldn't mind.  But leaving it to an application or for a human to
> sort out is OK I guess.  There are lots of non-portable numbers in
> proc.

Hmm, I do not think we want non-portable numbers in proc. What are
other examples?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
