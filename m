Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbYL0Blm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbYL0Blm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 20:41:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbYL0Bld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 20:41:33 -0500
Received: from mx0.towertech.it ([213.215.222.73]:51612 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752084AbYL0Blc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 20:41:32 -0500
Date: Sat, 27 Dec 2008 02:41:29 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Soekris net5501 board support code
Message-ID: <20081227024129.7ec4fd7e@i1501.lan.towertech.it>
In-Reply-To: <49557CEA.4030109@zytor.com>
References: <20081226022602.342db591@i1501.lan.towertech.it>
	<20081226164156.371a8b14.akpm@linux-foundation.org>
	<49557CEA.4030109@zytor.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Dec 2008 16:55:06 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> >>  arch/x86/Kconfig          |    9 +++
> >>  arch/x86/kernel/Makefile  |    1 
> >>  arch/x86/kernel/soekris.c |  128 ++++++++++++++++++++++++++++++++++++++++++++++
> > 
> > You might want to tell the x86 maintainers about this :)
> 
> The current consensus (to the extent that one exists) seems to be that
> platform device drivers belong in drivers[/platform]/x86, instead of in
> arch/x86.  drivers/platform doesn't exist in the current -linus tree,
> but Len Brown has patches to do it which should be pushed upstream in
> this merge window.  In the meantime, use the old name drivers/misc (a
> misnomer today, but won't be for much longer.)

 Hi Peter,

   I'm awaiting feedback from the geode mailing list to see if they
 want to move to the GPIO class and thus instantiate the GPIO
 devices in geode_32.c.

 The remaining pieces (LEDS) could then be moved to drivers/platform, even if
 it's not a real driver.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

