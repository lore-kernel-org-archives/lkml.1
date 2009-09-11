Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbZIKWek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbZIKWek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 18:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750857AbZIKWek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 18:34:40 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:43778 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbZIKWej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 18:34:39 -0400
Date: Fri, 11 Sep 2009 15:34:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, arve@android.com, swetland@google.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [patch] Re: newer version of HTC Dream support
Message-Id: <20090911153422.7d523a73.randy.dunlap@oracle.com>
In-Reply-To: <20090911212751.GA25544@elf.ucw.cz>
References: <20090824092204.GB25591@elf.ucw.cz>
	<20090901131832.GA1835@ucw.cz>
	<20090904090303.024e981a.randy.dunlap@oracle.com>
	<20090911071155.GA1386@ucw.cz>
	<20090911075847.2fb7210a.randy.dunlap@oracle.com>
	<20090911161335.GA8137@elf.ucw.cz>
	<20090911092157.ba202b0a.randy.dunlap@oracle.com>
	<20090911212751.GA25544@elf.ucw.cz>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4AAAD070.01D9:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Sep 2009 23:27:52 +0200 Pavel Machek wrote:

> 
> > > > Can you do b. (boot) without a. (compile)?
> > > 
> > > Well, hardly, but I can do a) without b), and it is very much
> > > easier. So... which is it?
> > 
> > I'm only targeting compile/build.
> 
> Ok, I guess I should appologize for testing patch in wrong
> configuration. This should fix it:
> 
> ---
> 
> Fix compilation of gpio_* input drivers on -next kernel. Adds needed
> headers and removes unprotected wakelock/earlysuspend dependencies.
>     
> Signed-off-by: Pavel Machek <pavel@ucw.cz>



Still doesn't build for me, but if it builds for you, that's great.
(could be a tool chain problem on my side)

(I had to enable CONFIG_ANDROID [due to staging/Makefile:
obj-$(CONFIG_ANDROID)		+= dream/
] to get dream code to try to build,
but I think that this has already been mentioned.)



Where is these header files?

(from linux-next-20090911:)

drivers/staging/dream/camera/msm_camera.c:21:32: linux/android_pmem.h: No such file or directory
drivers/staging/dream/camera/msm_vfe7x.c:8:32: linux/android_pmem.h: No such file or directory
drivers/staging/dream/camera/msm_vfe7x.c:9:27: mach/msm_adsp.h: No such file or directory
drivers/staging/dream/camera/msm_camera.c:23:30: media/msm_camera.h: No such file or directory
drivers/staging/dream/camera/msm_vfe7x.h:6:30: media/msm_camera.h: No such file or directory



---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
