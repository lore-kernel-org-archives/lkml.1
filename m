Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935499Ab0BZH6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 02:58:04 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46454 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935455Ab0BZH6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 02:58:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Q30y2sFXa8QtSNOtgFDCGtzvZpK2DUkRQLpJYOz7NiNvs85of0dILHH4Y5QuTkbRCi
         XJrzR6Zdi+R6zezlk05RBAUiW9idGXVR4FbNsBWqh2s/j4LUbH2qgKEkBr7Q9n5PA9Lq
         sviVNfLNjupHt19boYRzNdmfMRlb4pEiTCEvA=
Date: Thu, 25 Feb 2010 23:57:56 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kgdb-bugreport@lists.sourceforge.net
Subject: Re: [PATCH 14/28] kgdboc,keyboard: Keyboard driver for kdb with kgdb
Message-ID: <20100226075755.GC17062@core.coreip.homeip.net>
References: <1267132893-23624-1-git-send-email-jason.wessel@windriver.com>
 <1267132893-23624-15-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267132893-23624-15-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

Sorry for not responding earlier.

On Thu, Feb 25, 2010 at 03:21:19PM -0600, Jason Wessel wrote:
> +++ b/drivers/char/kdb_keyboard.c

Does it have to live here? If you are going for completely separate
driver maybe it should be buried somewhere like xxx/kdb/kdb_keyboard.c
so nobody needs to look at it?

> diff --git a/drivers/char/kdb_keyboard.h b/drivers/char/kdb_keyboard.h
> new file mode 100644
> index 0000000..5541668
> --- /dev/null
> +++ b/drivers/char/kdb_keyboard.h
> @@ -0,0 +1,143 @@
> +/*
> + *	include/linux/pc_keyb.h
> + *
> + *	PC Keyboard And Keyboard Controller
> + *
> + *	(c) 1997 Martin Mares <mj@atrey.karlin.mff.cuni.cz>
> + */

The above notwithstanding maybe we should not be bringing 2.4 codebase
as is in 2.6 and instead use (and extend as needed) definitions that are
already present?

-- 
Dmitry
