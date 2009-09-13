Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbZIMXWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbZIMXWK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 19:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbZIMXWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 19:22:09 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:17296 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbZIMXWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 19:22:08 -0400
Date: Sun, 13 Sep 2009 16:21:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, arve@android.com, swetland@google.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [patch] Re: newer version of HTC Dream support
Message-Id: <20090913162154.ee412cbe.randy.dunlap@oracle.com>
In-Reply-To: <20090913223806.GB9522@elf.ucw.cz>
References: <20090901131832.GA1835@ucw.cz>
	<20090904090303.024e981a.randy.dunlap@oracle.com>
	<20090911071155.GA1386@ucw.cz>
	<20090911075847.2fb7210a.randy.dunlap@oracle.com>
	<20090911161335.GA8137@elf.ucw.cz>
	<20090911092157.ba202b0a.randy.dunlap@oracle.com>
	<20090911212751.GA25544@elf.ucw.cz>
	<20090911153422.7d523a73.randy.dunlap@oracle.com>
	<20090913083719.GA6645@elf.ucw.cz>
	<20090913135422.f2d7cb88.randy.dunlap@oracle.com>
	<20090913223806.GB9522@elf.ucw.cz>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt010.oracle.com [141.146.116.19]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4AAD7E95.0044:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Sep 2009 00:38:07 +0200 Pavel Machek wrote:


Hi Pavel,
Sorry I missed the compile but not link distinction.


> Puzzle is almost over. If you disable 

Yes, much closer now.


> #obj-y += audio_out.o audio_in.o audio_mp3.o audmgr.o audpp.o
> #obj-y += snd.o
> 
> from build, the rest should now build ok.

but still not link?

drivers/staging/dream/camera/msm_camera.c:1482: undefined reference to `msm_camera_flash_set_led_state'

CONFIG_MSM_CAMERA_FLASH=y



---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
