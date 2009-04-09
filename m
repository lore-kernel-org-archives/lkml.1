Return-Path: <linux-kernel-owner+w=401wt.eu-S936869AbZDIV56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936869AbZDIV56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 17:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762495AbZDIV5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 17:57:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48381 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759910AbZDIV5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 17:57:47 -0400
Date: Fri, 10 Apr 2009 00:00:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 2/2] Make relatime default
Message-ID: <20090409220043.GD3269@elf.ucw.cz>
References: <20090326170714.GF6239@mit.edu> <alpine.LFD.2.00.0903261015050.3032@localhost.localdomain> <20090326174956.GB7198@srcf.ucam.org> <20090326175314.GC7198@srcf.ucam.org> <20090326184838.26166549@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0903261525560.3032@localhost.localdomain> <20090409194624.GB1403@ucw.cz> <alpine.LFD.2.00.0904091343110.4583@localhost.localdomain> <20090409211501.GC3269@elf.ucw.cz> <alpine.LFD.2.00.0904091419140.4583@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904091419140.4583@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-04-09 14:20:40, Linus Torvalds wrote:
> 
> 
> On Thu, 9 Apr 2009, Pavel Machek wrote:
> > 
> > Well, stat() syscall no longer returns sane value in st_atime, while
> > all the userland stayed the same; only kernel changed. I believe that
> > is ABI change.
> 
> No. 
> 
> If you want the old abi, use "strictatime" in your /etc/fstime.
  ~~~~~~~~~~~~~~~~~~~~~~~~

So you agree it is an ABI change :-).

> No ABI changed. Just the default mount options changed to be what most 
> people (especially non-specialists) would likely want.

Maybe.

But lets see what awaits me with 2.6.30-rc1 update:

root@amd:~# mount /data -oremount,noatime
root@amd:~# mount /data -oremount,strictatime
mount: /data not mounted already, or bad option

...oh no, my mount is too old. My mount seems to be up-to-date with
debian testing. Should I have to install mount from sources just to
keep the compatible system settings?

There has to be a better way.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
