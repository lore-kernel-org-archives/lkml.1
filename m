Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbYKTUXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbYKTUXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 15:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbYKTUXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 15:23:14 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49247 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbYKTUXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 15:23:13 -0500
To: tj@kernel.org
CC: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu
In-reply-to: <1227190298-4585-1-git-send-email-tj@kernel.org> (message from
	Tejun Heo on Thu, 20 Nov 2008 23:11:33 +0900)
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations, take #2
References: <1227190298-4585-1-git-send-email-tj@kernel.org>
Message-Id: <E1L3G3Q-0006SJ-Uc@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 20 Nov 2008 21:23:08 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Thu, 20 Nov 2008, Tejun Heo wrote:
> This patchset is the second take of extend-FUSE patchset.  Changes
> from the last take[L] are...

I managed to review and apply this and the libfuse patches up to the
ioctl support.  After swithing _IOC_READ with _IOC_WRITE in the kernel
the example program actually worked :)

I removed ->unrestricted_ioctl() and associated code because it really
doesn't make any sense: the high level lib won't be used for CUSE
stuff, otherwise unrestrited ioctls are not allowed (and the interface
is rather horrible anyway).

The poll patches look OK at a first glance too, I'll review them
tomorrow.

Thanks,
Miklos
