Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529AbYKML5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbYKML5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 06:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbYKML5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 06:57:22 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42433 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbYKML5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 06:57:21 -0500
To: tj@kernel.org
CC: miklos@szeredi.hu, fuse-devel@lists.sourceforge.net, greg@kroah.com,
       linux-kernel@vger.kernel.org
In-reply-to: <491C0FA0.5070500@kernel.org> (message from Tejun Heo on Thu, 13
	Nov 2008 20:29:36 +0900)
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <48F4568B.7000609@kernel.org> <E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu> <491A96AE.3080600@kernel.org> <491BC3E3.7040903@kernel.org> <E1L0aEn-0006dh-BK@pomaz-ex.szeredi.hu> <491C0FA0.5070500@kernel.org>
Message-Id: <E1L0aox-0006iY-2L@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 13 Nov 2008 12:57:11 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008, Tejun Heo wrote:
> I don't really mind people doing strange things in userland as long as
> it's safe but you're the maintainer.  It's a bit strange to export the
> feature only for CUSE, so I'm a little bit hesitant.

You are starting from the fact that ioctl is a good API.  It's not,
it's a bad API, so I don't want to encourage the use of it.

>  I wanna make it
> useful for both.  So, at the kernel level, only well formed for FUSE and
> everything goes for CUSE.  Does that sound good enough?

With additional restrictions for ptraceability yes.  But if you just
restrict it to CUSE at first, that's fine by me as well :)

Thanks,
Miklos
