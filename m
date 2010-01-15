Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0AOIgY (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 03:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407Ab0AOIgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 03:36:23 -0500
Received: from mga07.intel.com ([143.182.124.22]:33790 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751257Ab0AOIgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 03:36:22 -0500
Message-Id: <89k83a$6u8c0e@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="233058318"
Date: Fri, 15 Jan 2010 08:36:13 +0000
To: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        DRI for Linux <dri-devel@lists.sourceforge.net>,
        David Airlie <airlied@linux.ie>, linux-fbdev@vger.kernel.org
Subject: Re: 2.6.33-rc4-git1 -- [drm:i915_gem_execbuffer] *ERROR* i915_gem_do_execbuffer returns -512
References: <a44ae5cd1001142018k1f6b741buf560edbda0ca6e33@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <a44ae5cd1001142018k1f6b741buf560edbda0ca6e33@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jan 2010 23:18:14 -0500, Miles Lane <miles.lane@gmail.com> wrote:
> I just hit this with 2.6.33-rc4-git1 and DRI modesetting enabled.  I
> don't know what event triggered the error.  I had resumed from suspend
> a long time before the error appeared in my dmesg output:
> 
> [ 8505.847430] [drm:i915_gem_execbuffer] *ERROR*
> i915_gem_do_execbuffer returns -512

Apologies, this is not an error. It is an interrupted system call with an
overzealous DRM_ERROR() -- we will hopefully remove this printk promptly.
-ickle

-- 
Chris Wilson, Intel Open Source Technology Centre
