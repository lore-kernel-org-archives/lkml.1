Return-Path: <linux-kernel-owner+w=401wt.eu-S1751276AbXCFUue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276AbXCFUue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 15:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbXCFUud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 15:50:33 -0500
Received: from mx0.towertech.it ([213.215.222.73]:56428 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751276AbXCFUuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 15:50:32 -0500
Date: Tue, 6 Mar 2007 21:50:23 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: david-b@pacbell.net, rol@as2917.net, "'Adrian Bunk'" <bunk@stusta.de>,
       linux-kernel@vger.kernel.org, a.zummo@towertech.it
Subject: Re: [rtc-linux] Re: 2.6.21-rc2 : Oops in rtc_cmos...
Message-ID: <20070306215023.1ec0a4d7@inspiron>
In-Reply-To: <200703061132.29331.david-b@pacbell.net>
References: <01b901c75fc1$2295d4c0$4b00a8c0@donald>
	<200703061132.29331.david-b@pacbell.net>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007 11:32:28 -0800
David Brownell <david-b@pacbell.net> wrote:

> > on then... My dmesg says, related to rtc :
> > 
> > ...
> > rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
> 
> I think the RTC core shouldn't emit this message; I'll send
> a patch.  It's just confusing on error paths; and on success
> paths it's less informative than a message from the driver
> itself could be.

 I would like a way to have a common "welcome" message among
 all the drivers. Please take this into account if you want
 to send a patch ;)


> > What does this all mean ? I thought an RTC Cmos was always there on a
> > standard PC motherboard... (that's why I had activated the option in the
> > first time).
> 
> You enabled CONFIG_RTC (under char drivers, "Enhanced Real Time Clock Support")
> so that driver has claimed the CMOS RTC instead of "rtc-cmos.c".  Disable it.
> Then you'll be able to use this driver with no little surprises.

 maybe we should consider this in the Kconfig.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

