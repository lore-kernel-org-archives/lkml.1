Return-Path: <linux-kernel-owner+w=401wt.eu-S1751883Ab0AZAku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab0AZAku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 19:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214Ab0AZAkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 19:40:49 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:58700 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab0AZAkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 19:40:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gLc/5+h+FMqP2XNgWKOsUXoupYghWOEGsPGgB+cJMVDvFZ3OvprWjY98IUWe8EjIwq
         3gpCHq8apno7P9+bT85AtJ4l9YjPDS/lbn4zUJcY6L8t79A066MSza+UJfO+vk9a9Ewd
         gfNkFV7c73rDrntAPRwNtzJq9pMbAxXnYkM00=
Subject: Re: [git pull] drm fixes queue
From: Kevin Winchester <kjwinchester@gmail.com>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1001250645040.2474@skynet.skynet.ie>
References: <alpine.DEB.2.00.1001250645040.2474@skynet.skynet.ie>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jan 2010 20:40:45 -0400
Message-ID: <1264466445.1510.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-25 at 06:46 +0000, Dave Airlie wrote:
> Hi Linus,
> 
> Please pull the 'drm-linus' branch from
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus
> 
> I was out last week for sick kid + LCA dash so stuff queued up behind me, 
> I've booted this across a few radeons.
> 
> core drm changes: one EDID parser fix - one slighty controversial revert
> 	a previous fix for FB blanking although correct, uncovered other
> 	bugs in Intel/radeon KMS drivers, so until fixes for them are available
> 	revert the part of the change the broke stuff.
> 
> nouveau: upstream fixes from F12 testing.
> radeon: fixes all over the place from F12 bugs and upstream AMD changes.
> 	DVI->DP convertors work again
> 	IRQ fixes that fix kexec regression
> 	atombios parser updates from AMD should fix s/r bugs on newer cards
> 	minor r100/r200 command stream parser fixes
> 
> Possible r600 local priv escalation fix, the r600 could be used to access
> system memory if someone was (a) really sneaky, (b) had a lot of time,
> however the commit msg covers it all.
> 
> TTM: fix race condition in object deletion handling
> vmware/staging: bunch of fixes from VMware for the staging driver
> 	
> 

I see that this has not been pulled yet - and of course it is likely due
to the fact that Linus is busy.  But just in case some user feedback
will make a difference, radeon KMS has been refusing to boot for me
since about -rc4 (panic in radeon_agp_init), and I am hoping that this
batch of fixes will correct the problem.

If, however, my hope is misplaced, feel free to let me know so that I
can write up a more formal bug report...

Thanks,

-- 
Kevin Winchester



