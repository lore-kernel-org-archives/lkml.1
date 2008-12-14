Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbYLOPrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbYLOPrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 10:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbYLOPrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 10:47:12 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47238 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbYLOPrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 10:47:11 -0500
Date: Sun, 14 Dec 2008 19:19:43 +0100
From: Pavel Machek <pavel@suse.cz>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Scott Lurndal <scott.lurndal@3leafsystems.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH v2] Add preadv and pwritev system calls.
Message-ID: <20081214181943.GB1440@ucw.cz>
References: <1229090440-32120-1-git-send-email-kraxel@redhat.com> <20081212152929.GM26095@parisc-linux.org> <494287D4.2070909@redhat.com> <20081212155113.GO26095@parisc-linux.org> <49428AFD.5090009@redhat.com> <20081212182929.GA9631@pendragon.3leafnetworks.com> <20081212190728.GC5774@flint.arm.linux.org.uk> <4942C1D0.1080009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4942C1D0.1080009@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-12-12 20:56:00, Gerd Hoffmann wrote:
> Russell King wrote:
> >> should be similar to pread/pwrite, e.g:
> >>
> >>     int preadv(fd, iovec, iovec_size, offset)
> > 
> > Yes, and that's easy for glibc to achieve.
> 
> This hints the ABI problem exists at syscall level only.  Is that
> correct?  So we can have
> 
> 	preadv(fd, vec, vlen, off)
> 
> argument ordering at app <-> glibc level and
> 
> 	preadv(fd, vec, off, vlen)
> 
> ordering at glibc <-> kernel (aka syscall) level and it works fine for
> ARM + MIPS + PARISC?

ltrace and strace would show different values; very misleading :-(.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
