Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbYJ1Our@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbYJ1Our (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 10:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbYJ1Ouk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 10:50:40 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:48226 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbYJ1Ouj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 10:50:39 -0400
Date: Tue, 28 Oct 2008 16:50:38 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Patrick McHardy <kaber@trash.net>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc2: runaway loop modprobe char-major-5-1
In-Reply-To: <49071A84.3080706@trash.net>
Message-ID: <Pine.SOC.4.64.0810281648200.969@math.ut.ee>
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

I am also using Debian unstable, up to date. Kernels are created with 
kernel-package and use fresh initramfs. Old kernel packages with old 
initramfs's work, haven't tried to recreate them yet, but it may well be 
a userspace problem. Will try to find out more.

-- 
Meelis Roos (mroos@linux.ee)
