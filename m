Return-Path: <linux-kernel-owner+w=401wt.eu-S1758880AbXEPNff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880AbXEPNff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 09:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbXEPNf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 09:35:29 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2058 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750940AbXEPNf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 09:35:28 -0400
Date: Tue, 15 May 2007 20:31:00 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Jean Delvare <khali@linux-fr.org>
Cc: Antonino Ingargiola <tritemio@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: CONFIG_BREAK_MY_MACHINE was Re: Linux 2.6.22-rc1
Message-ID: <20070515203059.GI6816@ucw.cz>
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org> <5486cca80705131010h2011487dnc948a3c57ce6decc@mail.gmail.com> <alpine.LFD.0.98.0705131046400.6739@woody.linux-foundation.org> <5486cca80705131150u313eeb43i30bf040e160ac419@mail.gmail.com> <20070514081022.7fcee97f@hyperion.delvare> <5486cca80705140134r318296b8k37ad6f4562b4b535@mail.gmail.com> <20070514141437.631fcfd1@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514141437.631fcfd1@hyperion.delvare>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Hardware Monitoring support  --->
> >   <*> Hardware Monitoring support
> >   <*> Abit uGuru
> >   <M> VIA686A
> >   <*> IBM Hard Drive Active Protection System (hdaps)
> > 
> > But I'm quite sure that the only module used is VIA686A (I'm
> > rebuilding to confirm).
> 
> This is a rather bad idea to build the abituguru and hdaps drivers into
> your kernel if you don't have these devices. Especially abituguru, as
> it does arbitrary port probing.

hdaps should be safe (DMI based whitelist, no?)

If abitguru breaks random machines, we probably should DMI whitelist,
too.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
