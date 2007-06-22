Return-Path: <linux-kernel-owner+w=401wt.eu-S1759979AbXFVRew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979AbXFVRew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 13:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbXFVRep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 13:34:45 -0400
Received: from mx0.towertech.it ([213.215.222.73]:52802 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753325AbXFVReo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 13:34:44 -0400
Date: Fri, 22 Jun 2007 19:34:31 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Tino Keitel <tino.keitel@gmx.de>
Cc: rtc-linux@googlegroups.com, Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>
Subject: Re: [rtc-linux] Re: rtc_cmos: error after first write to wakealarm
Message-ID: <20070622193431.71bed8b5@inspiron>
In-Reply-To: <20070619172429.GA30990@dose.home.local>
References: <20070615063308.GA18089@dose.home.local>
	<20070615155904.1d1da892.yoichi_yuasa@tripeaks.co.jp>
	<20070615070319.GA19455@dose.home.local>
	<20070619142404.42dcdc3c@inspiron>
	<20070619172429.GA30990@dose.home.local>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007 19:24:29 +0200
Tino Keitel <tino.keitel@gmx.de> wrote:

> > > Where is the documentation that describes that I have to disable it
> > > first, and how to do this? A migration document for
> > > /proc/acpi/alarm users would be nice, too.
> > 
> >  Well, I guess there is no documentation. Maybe we could add
> >  a dev_warn with an explicit message.
> 
> Isn't it somewhat ridiculous to plan the removal of a feature for
> several months, and then replace it with something that behaves
> differently without any documentation?
> 
> I still wonder how 'cat /sys/class/rtc/rtcX/wakealarm' is expected to
> behave. With 2.6.22-rc5, I get this:
> 
> $ echo 1182351177 > /sys/class/rtc/rtc0/wakealarm 
> $ cat /sys/class/rtc/rtc0/wakealarm
> 2051644873
> 
> There seems to be a constant difference of 869984896 seconds. Is this a
> bug?

 I'll have to check that. Sorry for the delay, i've been a bit busy.


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

