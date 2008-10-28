Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529AbYJ1N6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbYJ1N6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 09:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYJ1N6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 09:58:31 -0400
Received: from stinky.trash.net ([213.144.137.162]:64071 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbYJ1N6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 09:58:31 -0400
Message-ID: <49071A84.3080706@trash.net>
Date: Tue, 28 Oct 2008 14:58:28 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Meelis Roos <mroos@linux.ee>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc2: runaway loop modprobe char-major-5-1
References: <Pine.SOC.4.64.0810281212540.21462@math.ut.ee>
In-Reply-To: <Pine.SOC.4.64.0810281212540.21462@math.ut.ee>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Meelis Roos wrote:
> Tried 2.6.28-rc2 on my computers and got a boot hang on two of them - 
> Thinkpad X20 and desktop machine with Intel 845 chipset.
> 
> request_module: runaway loop modprobe char-major-5-1
> request_module: runaway loop modprobe char-major-5-1
> request_module: runaway loop modprobe char-major-5-1
> request_module: runaway loop modprobe char-major-5-1
> 
> and then hangs.
> 
> char-major-5-1 seems to mean ttyS0.

I'm seeing the same problem on a Debian unstable system using
initramfs and dm-crypt, but it seems to be caused by userspace
changes, using an old initramfs image with just the new modules
added manually works fine (well, breaks elsewhere).

module-init-tools is version 3.4-1.
