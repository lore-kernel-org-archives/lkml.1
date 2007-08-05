Return-Path: <linux-kernel-owner+w=401wt.eu-S932728AbXHEAmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728AbXHEAmc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 20:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758797AbXHEAmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 20:42:22 -0400
Received: from mx0.towertech.it ([213.215.222.73]:39628 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758309AbXHEAmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 20:42:21 -0400
Date: Sun, 5 Aug 2007 02:41:55 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: hpa@zytor.com, Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rtc-linux] Re: rtc max frequency setting
Message-ID: <20070805024155.057d051d@i1501.lan.towertech.it>
In-Reply-To: <46B5148E.50302@zytor.com>
References: <Pine.LNX.4.64.0708050042560.14443@fbirervta.pbzchgretzou.qr>
	<46B5148E.50302@zytor.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 04 Aug 2007 17:06:38 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> > with the old rtc.ko module, there was a /proc/sys/dev/rtc/max-user-freq 
> > that could be set. With rtc_cmos.ko (or the new rtc infrastructure in 
> > general), I am missing this file. Where can I set the max-user-freq now, 
> > or is this obsolete now? (mplayer prefers to have user-freq to be >= 1024.)
> > 
> 
> Qemu wants something like this too.  Both of these really want something
> else, which is a high-frequency userspace timer.
> 
> What is the best way to do that on modern kernels?

 The rtc class is missing sysfs interface to the maximum settable
 value. I guess I'll have to add it. I should be able to find the time
 in the next few days.

 However, I agree that they both shold be using an userspace
 high freq timer :)

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

