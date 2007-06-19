Return-Path: <linux-kernel-owner+w=401wt.eu-S1757247AbXFSMYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbXFSMYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 08:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbXFSMYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 08:24:14 -0400
Received: from mx0.towertech.it ([213.215.222.73]:43850 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753162AbXFSMYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 08:24:13 -0400
Date: Tue, 19 Jun 2007 14:24:04 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: tino.keitel@gmx.de, Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] Re: rtc_cmos: error after first write to wakealarm
Message-ID: <20070619142404.42dcdc3c@inspiron>
In-Reply-To: <20070615070319.GA19455@dose.home.local>
References: <20070615063308.GA18089@dose.home.local>
	<20070615155904.1d1da892.yoichi_yuasa@tripeaks.co.jp>
	<20070615070319.GA19455@dose.home.local>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007 09:03:19 +0200
Tino Keitel <tino.keitel@gmx.de> wrote:

> > > I have the following strange behaviour with rtc_cmos:
> > > 
> > > $ echo 1181934240 > /sys/class/rtc/rtc0/wakealarm
> > > bash: echo: write error: Device or resource busy
> > > $ rmmod rtc_cmos
> > > $ modprobe rtc_cmos
> > > $ echo 1181934240 > /sys/class/rtc/rtc0/wakealarm
> > > $ echo 1181934240 > /sys/class/rtc/rtc0/wakealarm
> > > bash: echo: write error: Device or resource busy
> > > $
> > 
> > If the alarm has already been enabled, you cannot set the next alarm. 
> > You should disable first.
> 
> Ah, ok.
>   
> Where is the documentation that describes that I have to disable it
> first, and how to do this? A migration document for /proc/acpi/alarm   
> users would be nice, too.

 Well, I guess there is no documentation. Maybe we could add
 a dev_warn with an explicit message.


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

