Return-Path: <linux-kernel-owner+w=401wt.eu-S1764450AbYD3XBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764450AbYD3XBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 19:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbYD3XBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:01:45 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:59784 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbYD3XBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:01:44 -0400
Date: Thu, 1 May 2008 02:01:00 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Ingo, no more kconfig patches
Message-ID: <20080430230100.GK29330@cs181133002.pp.htv.fi>
References: <20080430200340.GA13757@elte.hu> <20080430170125.ZZRA012@mailhub.coreip.homeip.net> <20080430211317.GA24633@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080430211317.GA24633@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 11:13:17PM +0200, Ingo Molnar wrote:
> 
> * Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> 
> > > which triggers with the following config:
> > > 
> > >  http://redhat.com/~mingo/misc/config-Wed_Apr_30_21_43_17_CEST_2008.bad
> > > 
> > > the reason is dependency on NEW_LEDS that was not spelled out in the 
> > > Kconfig entry of JOYSTICK_XPAD.
> > 
> > Xpad can be compiled without LED support so this dependancy is 
> > incorrect. JOYSTICK_XPAD_LEDS has proper dependancy on LEDS_CLASS, the 
> > rest is Kconfig breakage.
> 
> no, you are wrong, read the current Kconfig rules again. If the user can 
> create a .config that does not build, it is driver breakage. It always 
> was, and has been in the past 15 years.
> 
> Kconfig might be extended to make dependencies easier to manage for 
> developers but until that is implemented you have to craft your driver's 
> dependencies with the current tools in a way that doesnt break the 
> build.

Ingo, there are areas in the kernel you know well.

But kconfig is not among them.

This breakage with your .config is *not* caused by an input bug as you 
wrongly claim (I'll send a correct fix after some testing).

And the commit that broke it even contains a
  Signed-off-by: Ingo Molnar <mingo@elte.hu>

I would really appreciate it if you could send the error message and the 
.config but not quick kconfig patches that are often wrong and that you 
try to push through the maintainers as you tried here.

Toralf, who does randconfig testing for some years, does exactly this, 
and the maintainers and/or I usually pick up his bug reports and work on
getting them fixed properly.

> 	Ingo

Thanks in advance
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

