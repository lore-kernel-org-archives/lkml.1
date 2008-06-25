Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbYFYGHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbYFYGHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 02:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbYFYGHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 02:07:41 -0400
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:3293 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbYFYGHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 02:07:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for June 24 (ivtv)
Date: Wed, 25 Jun 2008 08:05:15 +0200
User-Agent: KMail/1.9.7
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, v4l-dvb-maintainer@linuxtv.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       ivtv-devel@ivtvdriver.org
References: <20080624175612.cdf29651.sfr@canb.auug.org.au> <20080624172414.22c91416.randy.dunlap@oracle.com>
In-Reply-To: <20080624172414.22c91416.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806250805.15749.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 June 2008 02:24:14 Randy Dunlap wrote:
> ivtv-ioctl.c uses struct fields that are protected by
> CONFIG_VIDEO_ADV_DEBUG even when that config option is not set,
> causing:
>
> build-r2146.out:/local/linsrc/linux-next-20080624/drivers/media/video
>/ivtv/ivtv-ioc tl.c:1899: error: 'struct video_device' has no member
> named 'vidioc_g_register'
> build-r2146.out:/local/linsrc/linux-next-20080624/drivers/media/video
>/ivtv/ivtv-ioc tl.c:1900: error: 'struct video_device' has no member
> named 'vidioc_s_register' build-r2146.out:make[5]: ***
> [drivers/media/video/ivtv/ivtv-ioctl.o] Error 1
>
>
> ---
> ~Randy
> Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
> http://linuxplumbersconf.org/

Hi Randy,

Thanks for the report. It's fixed in my tree and will find it's way 
upstream soon.

Regards,

	Hans
