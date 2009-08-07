Return-Path: <linux-kernel-owner+w=401wt.eu-S1751924AbZHHPX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbZHHPX7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 11:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbZHHPX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 11:23:58 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42704 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbZHHPX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 11:23:57 -0400
Date: Fri, 7 Aug 2009 20:07:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ossama Othman <ossama.othman@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Moorestown RAR Handler driver, MRST 2.6.31-rc3
Message-ID: <20090807180728.GA1728@ucw.cz>
References: <1249082419-27718-1-git-send-email-ossama.othman@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249082419-27718-1-git-send-email-ossama.othman@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This driver implements an allocator interface for Moorestown
> restricted access regions (RAR), which are regions of RAM that are
> inaccessible by the CPU when locked down.  It is implemented in the
> kernel space since both user space applications and kernel drivers
> will be allocating buffers in Moorestown RARs.

How will userland applications use memory that's not even accessible
to CPU? This is rather new user/kernel API so a documentation would be
nice.


> index 1f73364..8fb9626 100644
> --- a/kernel-mrst-alpha2.config
> +++ b/kernel-mrst-alpha2.config
> @@ -1,7 +1,7 @@
>  #
>  # Automatically generated make config: don't edit
>  # Linux kernel version: 2.6.31-rc1
> -# Wed Jul 22 08:39:33 2009
> +# Wed Jul 29 02:59:24 2009
>  #

Stray diff? This file is unlikely to be in kernel.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
