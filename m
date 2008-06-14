Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbYFNLdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbYFNLdk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 07:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbYFNLda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 07:33:30 -0400
Received: from mx0.towertech.it ([213.215.222.73]:59131 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750771AbYFNLda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 07:33:30 -0400
Date: Sat, 14 Jun 2008 13:33:27 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: bunk@kernel.org, david-b@pacbell.net, Ingo Molnar <mingo@elte.hu>,
       Lior Dotan <liodot@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [rtc-linux] Re: [Bug 10866] /dev/rtc was missing until I
 disabled CONFIG_RTC_CLASS
Message-ID: <20080614133327.3d66d529@i1501.lan.towertech.it>
In-Reply-To: <20080614111806.GF1716@cs181133002.pp.htv.fi>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik>
	<200806131343.41213.david-b@pacbell.net>
	<20080613210257.GA529@elte.hu>
	<200806131538.54254.david-b@pacbell.net>
	<20080614113535.4d611e07@i1501.lan.towertech.it>
	<20080614111806.GF1716@cs181133002.pp.htv.fi>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jun 2008 14:18:06 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> 
> If Lior's problem was due to something like CONFIG_RTC_CLASS=y, 
> CONFIG_RTC_DRV_CMOS=n that's a kernel configuration that would
> anyway break when the old driver gets removed, and it just broke
> earlier.

 I haven't seen the .config, but CONFIG_RTC_CLASS=y
 and CONFIG_RTC_DRV_CMOS=n is perfectly legal.

 It just don't have to be put in the default x86 config maybe,
 but it's legal..
 
> Everyone seems to focus on this kconfig related case, what about my 
> point of no /dev/rtc with a static /dev ? When talking about existing 
> setups and embedded systems that's a real issue for some systems.

 the device node creation is yet another option of the
 rtc class. it should be on by default in any defconfig, I'd guess.

 But then you'll get /dev/rtc0 without any specific device node.

 As I said in the past, I'd accept a patch to handle this special
 case of having /dev/rtc with a specific major and minor, but I'm against
 it.

 It would be better to upgrade your userspace when such big changes
 happens in the kernel. In fact, it the first time that the rtc
 has been touched in the last.. 10 year? I think it's not unreasonable to
 ask to upgrade userspace.

 wrto embedded systems, having worked with them for years, you are expected
 to check every detail of every new kernel you want to use before releasing
 it or, say, uploading it to your lander on the moon :)
 



-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

