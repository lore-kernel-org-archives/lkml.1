Return-Path: <linux-kernel-owner+w=401wt.eu-S937226AbXGSInZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937226AbXGSInZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 04:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933104AbXGSInL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 04:43:11 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:36447 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763105AbXGSInK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 04:43:10 -0400
Date: Thu, 19 Jul 2007 09:02:03 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: cmpxchg is not available to generic code
In-Reply-To: <20070719000549.1e57b5b2.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707190900320.19586@skynet.skynet.ie>
References: <20070719000549.1e57b5b2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> arm:
>
> drivers/char/drm/drm_lock.c: In function `drm_lock_take':
> drivers/char/drm/drm_lock.c:221: error: implicit declaration of function `cmpxchg'
>
> You might be able to use atomic_cmpxchg, which _is_ present
> on all architectures.  Or use a spinlock.
>
> What's that code doing anyway?  driver-private locking primitives?

When did arm suddenly start wanting DRM? they need to grow a userpsace 
cmpxchg as davem mentioned to go along with this, changing the drm now 
isn't possible due to backwards compat..

Dave.

-- 
David Airlie, Software Engineer
http://www.skynet.ie/~airlied / airlied at skynet.ie
Linux kernel - DRI, VAX / pam_smb / ILUG

