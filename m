Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbZAKVr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbZAKVr0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 16:47:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbZAKVrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 16:47:17 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:16087 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbZAKVrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 16:47:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ognX/lLUODm0R273IDzzk+wo8Xs98hDqWbHZlVLGWuJYj2XwtTIFlIK/Z37TQagIHf
         94ASciG1+UK0JkDomM7MeUiQLp/w5Q27Nkcma+yoYmmzPvA/keuhcghaxoamYJ0nJOzO
         eUJJpDA1tefestzgD3ykAuPLdEaqVJrRpuEXU=
Message-ID: <21d7e9970901111339q705bcea4i44941bfd84a075fe@mail.gmail.com>
Date: Mon, 12 Jan 2009 07:39:29 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Diego Calleja" <diegocg@gmail.com>
Subject: Re: intel kms "Failed to allocate space for kernel memory manager"
Cc: "Jan Dittmer" <jdi@l4x.org>, linux-kernel@vger.kernel.org,
       eric.anholt@iintel.com, airlied@linux.ie
In-Reply-To: <20090111222122.4d0cb146@diego-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <621d098f0901110546p2b99a525k5de54e37fa181197@mail.gmail.com>
	 <621d098f0901110551v5a05f69aqc4e06a6905989d6e@mail.gmail.com>
	 <20090111222122.4d0cb146@diego-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 7:21 AM, Diego Calleja <diegocg@gmail.com> wrote:
> I also have a failure with KMS, it's different than yours but I'll post it
> in this thread...xserver-xorg-video-intel version 2.5.1 (whatever there is
> in ubuntu unstable repositories)

Read the kconfig option before you enabled kms by default?

if not, you cannot just enable kms and have old userspace drivers
work, there is no
released userspace for this yet, as that would put the chicken before the egg.

Dave.

>
> -----------------------------------------------
> (II) [drm] DRM interface version 1.3
> (II) [drm] DRM open master succeeded.
> (II) intel(0): [drm] Using the DRM lock SAREA also for drawables.
> (II) intel(0): [drm] framebuffer mapped by ddx driver
> (II) intel(0): [drm] added 1 reserved context for kernel
> (II) intel(0): X context handle = 0x1
> (II) intel(0): [drm] installed DRM signal handler
> (**) intel(0): Framebuffer compression disabled
> (**) intel(0): Tiling enabled
> (==) intel(0): VideoRam: 262144 KB
> (II) intel(0): Attempting memory allocation with tiled buffers.
> (II) intel(0): Tiled allocation successful.
>
> Fatal server error:
> AddScreen/ScreenInit failed for driver 0
> -----------------------------------------------
>
> Full X.org log attached.
