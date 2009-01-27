Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbZA0LWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbZA0LWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 06:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbZA0LWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 06:22:01 -0500
Received: from mx0.towertech.it ([213.215.222.73]:35959 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751777AbZA0LWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 06:22:01 -0500
Date: Tue, 27 Jan 2009 12:21:56 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Ed Swierk <eswierk@aristanetworks.com>
Cc: rtc-linux@googlegroups.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: i2c rtc instead of cmos rtc
Message-ID: <20090127122156.784924f4@i1501.lan.towertech.it>
In-Reply-To: <1233018263.14510.112.camel@localhost.localdomain>
References: <1233018263.14510.112.camel@localhost.localdomain>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009 17:04:23 -0800
Ed Swierk <eswierk@aristanetworks.com> wrote:

> Allows the user to ignore the cmos real-time clock normally found on x86
> boards, and to use an i2c rtc in its place.  This is intended to be used
> with with CONFIG_RTC_HCTOSYS=y to set the system clock from the rtc
> automatically during boot, and with CONFIG_RTC_SYSTOHC=y to have ntpd
> update the rtc (see separate patch).

 can't you just avoid compiling rtc cmos? or compile it as a module and
 load the i2c rtc first?

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

