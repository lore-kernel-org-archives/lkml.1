Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbZLYMk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbZLYMk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 07:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbZLYMk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 07:40:58 -0500
Received: from mx.treblig.org ([80.68.94.177]:60159 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbZLYMk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 07:40:57 -0500
Date: Fri, 25 Dec 2009 12:35:50 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Andrei Gaponenko <andrei.gaponenko@cern.ch>, linux-kernel@vger.kernel.org,
       Alex Deucher <alexdeucher@gmail.com>
Subject: Re: drm/radeon/kms regression: 2.6.33-rc2 does not boot
Message-ID: <20091225123549.GA26202@gallifrey>
References: <alpine.LFD.2.00.0912250124410.11466@x200s> <21d7e9970912250146s3e36cb9vcfc12a42445b37a2@mail.gmail.com> <alpine.LFD.2.00.0912250204220.11466@x200s> <21d7e9970912250232uebe337eu520a7fa98d21c293@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970912250232uebe337eu520a7fa98d21c293@mail.gmail.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.31.5-kvm-i386-2009-10-30 (i686)
X-Uptime: 12:21:44 up 39 days, 19:31,  1 user,  load average: 0.01, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Airlie (airlied@gmail.com) wrote:
> On Fri, Dec 25, 2009 at 8:08 PM, Andrei Gaponenko

<snip>

> >> Can you wait for a minute or so and see if it continues? though this sounds like
> >> something different than others have seen.
> >
> > I did let it to sit for many minutes during some of iterations of the
> > bisection; did not notice any progress.
> >
> > Andrei
> >
> > Please Cc me directly on replies.
> 
> Did you install the irq firmware from
> http://people.freedesktop.org/~agd5f/radeon_ucode/
> 
> I need to add a pointer to the Kconfig (just wasn't there when I sent it i).

I had the same problem (and the same fix); For me it gave up after 60
seconds of waiting for the firmware and panic'd.

Unfortunately at that point it was still at a VGA display without
much res, so while I got the backtrace I didn't get the top of the oops.
(and it was too early for netconsole)

It would be better if the firmware was missing for it just not to do 
modeswitching and carry on; I wonder if it was hangcheck or the like
that killed it?

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
