Return-Path: <linux-kernel-owner+w=401wt.eu-S1030827AbXAZJbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030827AbXAZJbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 04:31:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965602AbXAZJbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 04:31:36 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4035 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965618AbXAZJbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 04:31:35 -0500
Date: Wed, 24 Jan 2007 17:08:19 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Samium Gromoff <_deepfire@feelingofgreen.ru>
Cc: Jakub Jelinek <jakub@redhat.com>, Alan <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Define the EF_AS_NO_RANDOM e_flag bit
Message-ID: <20070124170819.GA3953@ucw.cz>
References: <200701221520.l0MFKLdK032645@turing-police.cc.vt.edu> <871wlnq7ue.wl@betelheise.deep.net> <20070123084805.GB5560@ucw.cz> <87mz4996wg.wl@betelheise.deep.net> <20070123154127.57059632@localhost.localdomain> <877ivd8p42.wl@betelheise.deep.net> <20070123205017.GH29911@devserv.devel.redhat.com> <874pqh8nbu.wl@betelheise.deep.net> <20070123211612.GJ29911@devserv.devel.redhat.com> <871wll8h2t.wl@betelheise.deep.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871wll8h2t.wl@betelheise.deep.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Should we introduce per-arch asm/elf.h files to hold the relevant flag definitions then?
> > 
> > On some architectures there are no bits left.  On others you'd need to go
> > through whomever maintains the relevant psABI to get a bit officially
> > allocated.  Really, it is very bad idea to use e_flags for this.
> 
> How does one find the relevant maintainers?

Andi Kleen maintains both i386 and x86-64, so it should be easy.

(Ouch and make it one patch, it is too short to split...)

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
