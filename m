Return-Path: <linux-kernel-owner+w=401wt.eu-S934062AbXCTUVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934062AbXCTUVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 16:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934066AbXCTUVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 16:21:49 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35042 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934062AbXCTUVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 16:21:49 -0400
Date: Tue, 20 Mar 2007 21:21:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-pm@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] 2.6.21-rc4-mm1
Message-ID: <20070320202141.GA3604@elf.ucw.cz>
References: <20070319205623.299d0378.akpm@linux-foundation.org> <45FFF026.4030502@gmail.com> <20070320080944.9cb3c765.akpm@linux-foundation.org> <20070320183821.GD2670@elf.ucw.cz> <4600389E.6030901@gmail.com> <20070320195659.GA3545@elf.ucw.cz> <46004080.6080202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46004080.6080202@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>>> Also, it might be useful to add a temporary /proc/freeze-unfreeze thing
> >>>> which will simply do a freeze/unfreeze cycle.  Then we can apply various
> >>>> workloads to the machine while madly stressing the freezer code.  
> >>> echo testproc > /sys/power/disk; echo disk > /sys/power/state ... is
> >>> pretty much what you want.
> >> Ok, I'll try this.
> > 
> > It will not help you -- probably -- it is equivalent to just running
> > s2ram. But it should make "successful" testing easier, because you no
> > longer need machine with working suspend to test refrigerator.
> 
> Aha, I didn't read it carefully. Suspend is working, but not in this kernel.
> I haven't tried s2ram in this version. Should I (I'm away from it) -- would
> it show something?

No, probably not. git bisect would help, but I guess it is easier to
let Rafael sort it out.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
