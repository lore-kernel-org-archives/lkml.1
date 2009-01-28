Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbZA1Trs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbZA1Trs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 14:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbZA1Trj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 14:47:39 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58716 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbZA1Tri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 14:47:38 -0500
Date: Wed, 28 Jan 2009 19:47:23 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, Dirk@Opfer-Online.de, arminlitzel@web.de,
       pavel.urban@ct.cz, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       milan@ucw.cz
Subject: Re: 2.6.29-rc1 on zaurus (spitz)
Message-ID: <20090128194723.GA1394@flint.arm.linux.org.uk>
References: <20090128113809.GA29424@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128113809.GA29424@elf.ucw.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 12:38:09PM +0100, Pavel Machek wrote:
> Hi!
> 
> 2.6.29-rc1 was great step forward over previous kernels: it not only
> displays something on screen but also mounts root
> filesystem. Unfortunately it then panics with "attempted to kill
> init".
> 
> I tried both with CONFIG_EABI=N and  CONFIG_EABI=Y, OABI_COMPAT=Y. Any
> more tricks I should try?

Don't enable EABI unless you have changed userspace to be EABI compliant.
Also check that you have NWFPE enabled if you're not using a soft-float
userspace.

You could also build the kernel with DEBUG_USER enabled and pass
user_debug=-1 on the kernel's command line, and see if you get any more
information.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
