Return-Path: <linux-kernel-owner+w=401wt.eu-S1753666AbZGTVMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbZGTVMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 17:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbZGTVMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 17:12:07 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:45579 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbZGTVMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 17:12:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=B5HKzI7afATF7ZVMWgi+ckXl4g8hjhmAXgc0U5/A2W5c0ywrR0bixmB92EeLVzzMl3
         JeAZ1c2bHVoqCbTLlRjxg2rhTCZSKhuo8tiLu5v+1iEdCQpOS4XaaEzuP1XC5qCkiQli
         ao/QhVol0KTd4oCFBOYrgnwQ4ZW5XRS2Hgl/A=
From: Alberto Gonzalez <alberto6674@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Kernel 2.6.30 and udevd problem
Date: Mon, 20 Jul 2009 23:06:51 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.29-ARCH; KDE/4.2.4; x86_64; ; )
Cc: Alberto Gonzalez <alberto6674@gmail.com>, Michal Soltys <soltys@ziu.info>,
       Dave Airlie <airlied@linux.ie>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org
References: <200906280821.58631.info@gnebu.es> <200907050010.44254.info@gnebu.es> <20090720111010.28bf7b76@jbarnes-g45>
In-Reply-To: <20090720111010.28bf7b76@jbarnes-g45>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907202306.52305.info@gnebu.es>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 July 2009 20:10:10 Jesse Barnes wrote:
> Alberto Gonzalez <alberto6674@gmail.com> wrote:
> > I now tried a vanilla 2.6.30.1 kernel with a custom config (so I
> > don't have to wait 45 minutes for it to compile) and I still see the
> > problem. This is what I get in dmesg:
> >
> > [   83.506496] ------------[ cut here ]------------
> > [   83.506500] WARNING: at drivers/gpu/drm/drm_sysfs.c:452
> > drm_sysfs_hotplug_event+0x2b/0x63()
> > [   83.506502] Hardware name: Studio 540
> > [   83.506503] hotplug uevent
> > [   83.506504] Modules linked in:
> > [   83.506506] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
> > [   83.506507] Call Trace:
> > [   83.506511]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
> > [   83.506514]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
> > [   83.506517]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
> > [   83.506520]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
> > [   83.506523]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
> > [   83.506525]  [<c1032f28>] worker_thread+0x131/0x1ab
> > [   83.506528]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
> > [   83.506531]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
> > [   83.506534]  [<c1032df7>] ? worker_thread+0x0/0x1ab
> > [   83.506536]  [<c1035c84>] kthread+0x46/0x6a
> > [   83.506538]  [<c1035c3e>] ? kthread+0x0/0x6a
> > [   83.506541]  [<c10033cf>] kernel_thread_helper+0x7/0x10
> > [   83.506542] ---[ end trace 08f91010f92f7c3c ]---
>
> Sorry I missed this update; what about the register dump part of the
> patch?  Presumably you get a ton of these in your log, but with some
> IIR register info beforehand?

The problem is that when this happens I get these messages at a very high 
rate, so they flood my dmesg in a few seconds. Is there a way I could access 
that register dump that should precede them?

Thanks,
Alberto.

