Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbYJ2U2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbYJ2U2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 16:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbYJ2U2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 16:28:03 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:34945 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222AbYJ2U2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 16:28:00 -0400
Date: Wed, 29 Oct 2008 22:27:58 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Patrick McHardy <kaber@trash.net>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc2: runaway loop modprobe char-major-5-1
In-Reply-To: <49071A84.3080706@trash.net>
Message-ID: <Pine.SOC.4.64.0810292216070.29872@math.ut.ee>
References: <Pine.SOC.4.64.0810281212540.21462@math.ut.ee> <49071A84.3080706@trash.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm seeing the same problem on a Debian unstable system using
> initramfs and dm-crypt, but it seems to be caused by userspace
> changes, using an old initramfs image with just the new modules
> added manually works fine (well, breaks elsewhere).

Hmm, I recreated an initramfs for the working 2.7.27 kernel with the 
current tools and it created a working initramfs. Recreating the 
initramfs for 2.6.28-rc2 creates a nonworking initramfs. So it points 
towards the kernel, as the config of serial things has not changed 
(8250 serial driver built in in both kernels) and the same userspace 
toolchain makes working initramfs for old and nonworking for new 
kernel...

-- 
Meelis Roos (mroos@linux.ee)
