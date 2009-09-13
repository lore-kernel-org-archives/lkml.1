Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbZIMUyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbZIMUyh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 16:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbZIMUyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 16:54:36 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:27370 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbZIMUyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 16:54:35 -0400
Date: Sun, 13 Sep 2009 13:54:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, arve@android.com, swetland@google.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [patch] Re: newer version of HTC Dream support
Message-Id: <20090913135422.f2d7cb88.randy.dunlap@oracle.com>
In-Reply-To: <20090913083719.GA6645@elf.ucw.cz>
References: <20090824092204.GB25591@elf.ucw.cz>
	<20090901131832.GA1835@ucw.cz>
	<20090904090303.024e981a.randy.dunlap@oracle.com>
	<20090911071155.GA1386@ucw.cz>
	<20090911075847.2fb7210a.randy.dunlap@oracle.com>
	<20090911161335.GA8137@elf.ucw.cz>
	<20090911092157.ba202b0a.randy.dunlap@oracle.com>
	<20090911212751.GA25544@elf.ucw.cz>
	<20090911153422.7d523a73.randy.dunlap@oracle.com>
	<20090913083719.GA6645@elf.ucw.cz>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4AAD5C01.00A1:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Sep 2009 10:37:19 +0200 Pavel Machek wrote:

> Hi!
> 
> > > Fix compilation of gpio_* input drivers on -next kernel. Adds needed
> > > headers and removes unprotected wakelock/earlysuspend dependencies.
> > >     
> > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > 
> > Still doesn't build for me, but if it builds for you, that's great.
> > (could be a tool chain problem on my side)
> 
> No, it does not look like toolchain problem :-(. I had parts disabled
> in Kconfig. This should make it _compile_ (but not link); somehow
> MSM_ADSP is neccessary for camera to link and I can't see how to
> enable it.
> 
> Thanks for the patience.
> 								Pavel
> 
> ---
> 
> Add pieces neccessary for compilation of msm_camera.


drivers/staging/dream/camera/msm_camera.c:122: undefined reference to `get_pmem_file'
drivers/staging/dream/camera/msm_camera.c:305: undefined reference to `put_pmem_file'
drivers/staging/dream/camera/msm_vfe7x.c:173: undefined reference to `msm_adsp_enable'
drivers/staging/dream/camera/msm_vfe7x.c:186: undefined reference to `msm_adsp_disable'
drivers/staging/dream/camera/msm_vfe7x.c:195: undefined reference to `msm_adsp_write'
drivers/staging/dream/camera/msm_vfe7x.c:225: undefined reference to `msm_adsp_put'
drivers/staging/dream/camera/msm_vfe7x.c:264: undefined reference to `msm_adsp_get'


hint:  CONFIG_MSM_ADSP is not enabled.  I don't see a way to enable it.


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
