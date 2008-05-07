Return-Path: <linux-kernel-owner+w=401wt.eu-S1757144AbYEGLto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbYEGLto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 07:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217AbYEGLte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 07:49:34 -0400
Received: from mx0.towertech.it ([213.215.222.73]:49778 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754054AbYEGLtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 07:49:33 -0400
Date: Wed, 7 May 2008 13:49:30 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: dwmw2@infradead.org, Ralf Baechle <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] Re: [RFC][PATCH 1/4] RTC: Class device support for
 persistent clock
Message-ID: <20080507134930.47d5ed6d@i1501.lan.towertech.it>
In-Reply-To: <1210148655.25560.825.camel@pmac.infradead.org>
References: <Pine.LNX.4.55.0805070015360.16173@cliff.in.clinika.pl>
	<1210148655.25560.825.camel@pmac.infradead.org>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 May 2008 09:24:15 +0100
David Woodhouse <dwmw2@infradead.org> wrote:


> Ooh, shiny -- you saved me the trouble of doing this (and hopefully also
> the trouble of looking through it to check whether all the callers of
> read_persistent_clock() can sleep, etc.?)

 I knew you would have liked that patch :)
 
> One thing I was going to do in rtc_update_persistent_clock() was make it
> use mutex_trylock() for grabbing rtc->lock. We go to great lengths to
> make sure we're updating the clock at the correct time -- we don't want
> to be doing things which delay the update. So we should probably just
> use mutex_trylock() and abort the update (this time) if it fails.

 agreable. 
 
> I was also thinking of holding the RTC_HCTOSYS device open all the time,
> too. If it's a problem that you then couldn't unload the module, perhaps
> a sysfs interface to set/change/clear which device is used for this?

 mm.. let's keep it easy. the chances the rtc is in use
 are usually real low.
 

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

