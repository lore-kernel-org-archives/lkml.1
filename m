Return-Path: <linux-kernel-owner+w=401wt.eu-S1757135AbYGZSOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135AbYGZSOQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 14:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbYGZSOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 14:14:01 -0400
Received: from mx0.towertech.it ([213.215.222.73]:60515 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752182AbYGZSOA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 14:14:00 -0400
Date: Sat, 26 Jul 2008 20:13:55 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: =?iso-8859-2?Q?Tom=E1=B9_Janou=B9ek?= <tomi@nomi.cz>
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] rtc-dev: stop periodic interrupts on device release
Message-ID: <20080726201355.064a789e@i1501.lan.towertech.it>
In-Reply-To: <20080726180610.GA12168@nomi.cz>
References: <20080726154617.GA5613@notes.lisk.in>
	<20080726195521.36d4d48c@i1501.lan.towertech.it>
	<20080726180610.GA12168@nomi.cz>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jul 2008 20:06:10 +0200
Tomáš Janoušek <tomi@nomi.cz> wrote:

> On Sat, Jul 26, 2008 at 07:55:21PM +0200, Alessandro Zummo wrote:
> >  I'm not sure this is appropriate. sometimes the PIE is used to control
> >  external hardware and it doesn't make sense to have an application that's
> >  always open to handle that. 
> > 
> >  Any app should be responsible to release what it has allocated, if appropriate,
> >  and not rely on someone else to do on his behalf.
> 
> mplayer and aireplay-ng have never done so. And what about crashes? Am I

 that's not an excuse, they have been written on a false assumption. Unless
 that behaviour is documented somewhere.


> supposed to create a small "rtcpieoff" applications and make it into all
> distributions so that everyone can clean up the mess?

 just send patches to mplayer and aireplay-ng and it will make in the distros.


> Additionally, it has been a regression against the old rtc and drivers like
> rtc-sh do so even today.

 Specific drivers might choice to do it on close. I believe rtc-cmos might
 be one of the few that might have to do it in order to cope with badly
 written programs. It's up to David to choice if it's appropriate too add it to
 rtc-cmos. 



-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

