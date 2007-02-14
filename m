Return-Path: <linux-kernel-owner+w=401wt.eu-S1751306AbXBNMUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbXBNMUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 07:20:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbXBNMUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 07:20:07 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56844 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751306AbXBNMUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 07:20:05 -0500
Date: Wed, 14 Feb 2007 13:17:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Jakub Jelinek <jakub@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [ANN] Userspace M-on-N threading model implementation. Alpha release.
Message-ID: <20070214121700.GB23857@elf.ucw.cz>
References: <66910A579C9312469A7DF9ADB54A8B7D5C2B90@exchange.ZeugmaSystems.local> <45C362D2.2040407@tmr.com> <1170516376.3073.1015.camel@laptopd505.fenrus.org> <45C63E30.4010106@tmr.com> <20070204202053.GC20307@devserv.devel.redhat.com> <45C65353.5000602@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C65353.5000602@tmr.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>How does that work? Switching between kernel threads requires going into 
> >>the kernel, user level thread switches are all done in user mode.
> >>
> >>Do you have some way to change o/s threads w/o going into the kernel?
> >>    
> >
> >But going into kernel is not very expensive on Linux.
> >
> >On the other side, the overhead you need to add for every single syscall
> >that might block for the M:N threads and the associated complications
> >which make it far harder to conform to POSIX IMHO far outweight the costs
> >of going into the kernel for a context switch.
> 
> That really wasn't my question, Arjan said that switching real threads 
> wasn't a context switch in the hardware sense, and I was asking if I 
> missed something. It may be cheap, but it would seem to be a context 
> switch none-the-less.

It is not reloading %cr3.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
