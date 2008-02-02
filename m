Return-Path: <linux-kernel-owner+w=401wt.eu-S1759499AbYBBLGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499AbYBBLGr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 06:06:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756666AbYBBLGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 06:06:39 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35629 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756404AbYBBLGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 06:06:38 -0500
Date: Sat, 2 Feb 2008 12:06:52 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Rik Bobbaers <Rik.Bobbaers@icts.kuleuven.be>
Cc: linux-kernel@vger.kernel.org
Subject: Re: how to tell i386 from x86-64 kernel
Message-ID: <20080202110652.GA5362@elf.ucw.cz>
References: <1201862849.6193.22.camel@lois>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201862849.6193.22.camel@lois>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-02-01 11:47:29, Rik Bobbaers wrote:
> hi there,
> 
> since i'm not on the list... how about:
> 
> tail /proc/1/smaps and check the address size...
> on 32 bit: ffffe000-fffff000 r-xp 00000000 00:00 0          [vdso]
> 
> on 64 bit: ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0
> [vdso]
> 
> there you can clearly see that your address space is double... so
> there's your 32 bit vs 64 bit
> 
> as a normal user, you can do the same but with your own processes

That tells you if _init_ is 32 or 64 bit, not kernel.

I'm running 32-bit distro on 64-bit kernel here. It works fine (as it
should).

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
