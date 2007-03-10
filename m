Return-Path: <linux-kernel-owner+w=401wt.eu-S932319AbXCJWtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319AbXCJWtm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 17:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932371AbXCJWtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 17:49:42 -0500
Received: from mail09.syd.optusnet.com.au ([211.29.132.190]:45229 "EHLO
	mail09.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932319AbXCJWtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 17:49:41 -0500
From: Con Kolivas <kernel@kolivas.org>
To: James Cloos <cloos@jhcloos.com>
Subject: Re: 2.6.21-rc3-mm1 RSDL results
Date: Sun, 11 Mar 2007 10:16:00 +1100
User-Agent: KMail/1.9.5
Cc: Matt Mackall <mpm@selenic.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
References: <20070309053931.GA10459@waste.org> <200703100807.43582.kernel@kolivas.org> <m3ejnxqbfl.fsf@lugabout.jhcloos.org>
In-Reply-To: <m3ejnxqbfl.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703111016.01154.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 March 2007 04:01, James Cloos wrote:
> >>>>> "Con" == Con Kolivas <kernel@kolivas.org> writes:
>
> Con> It's sad that sched_yield is still in our graphics card drivers ...
>
> I just did a recursive grep(1) on my mirror of the freedesktop git
> repos for sched_yield.  This only checked the master branches as I
> did not bother to script up something to clone each, check out all
> branches in turn, and grep(1) each possibility.
>
> The output is just:
> :; grep -r sched_yield FDO/xorg
>
> FDO/xorg/xserver/hw/kdrive/via/viadraw.c:		sched_yield();
> FDO/xorg/driver/xf86-video-glint/src/pm2_video.c:    if (sync) /*
> sched_yield? */
>
> Is there something else I should grep(1) for?  If not, it looks as
> if sched_yield(2) has been evicted from the drivers.

See:

http://webcvs.freedesktop.org/mesa/Mesa/src/mesa/drivers/dri/r200/r200_ioctl.c?revision=1.37&view=markup

-- 
-ck
