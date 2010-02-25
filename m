Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933492Ab0BYTls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 14:41:48 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:51163 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932931Ab0BYTlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 14:41:47 -0500
Date: Thu, 25 Feb 2010 20:41:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Greg KH <greg@kroah.com>, Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Iliyan Malchev <malchev@google.com>, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] staging/dream: add missing include files/fix
 compilation
Message-ID: <20100225194125.GA7645@elf.ucw.cz>
References: <20091225205917.GA25761@elf.ucw.cz>
 <20100115002419.GA25643@kroah.com>
 <20100119054516.GB22153@elf.ucw.cz>
 <1263914079.1951.43.camel@m0nster>
 <20100131084421.GG2238@elf.ucw.cz>
 <20100131092829.GJ2238@elf.ucw.cz>
 <1264953492.2059.5.camel@m0nster>
 <20100225193027.GA7391@elf.ucw.cz>
 <1267126586.5439.56.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267126586.5439.56.camel@c-dwalke-linux.qualcomm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > /home/dwalker/linux-2.6/drivers/video/msm/msm_fb.c:24: fatal error: linux/msm_mdp.h: No such file or directory
> > > compilation terminated.
> > > make[4]: *** [drivers/video/msm/msm_fb.o] Error 1
> > > make[3]: *** [drivers/video/msm] Error 2
> > > make[3]: *** Waiting for unfinished jobs....
> > > make[2]: *** [drivers/video] Error 2
> > > make[1]: *** [drivers] Error 2
> > > make: *** [sub-make] Error 2
> > 
> > Yes, framebuffer has problems.
> > 
> > > Even with the framebuffer off I still don't get any serial output on a
> > > plain 2.6.33-rc6 .. I'm using a config that you sent me when you first
> > > tested my -next tree .
> > 
> > 2.6.33 boots here, with attached config. I'll try -next next.
> 
> My -next tree hasn't changed much since you last looked at it .. I
> wouldn't bother testing it. I might take some small fixes from that tree
> to merge, but what's there is still too much of a mess to merge.

Ok, so your -next tree will not be merged for 2.6.34?

> I just pushed another tree called "working-mmc" which still needs some
> clean up but should have working mmc if you want to test that.

Do you have git url? Yes, I'd like to play.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
