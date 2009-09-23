Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbZIWHgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbZIWHgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 03:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbZIWHgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 03:36:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46338 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbZIWHgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 03:36:37 -0400
Date: Wed, 23 Sep 2009 09:36:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Greg KH <greg@kroah.com>, San Mehat <san@android.com>,
       Iliyan Malchev <ibm@android.com>, Brian Swetland <swetland@google.com>,
       devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] STAGING: includecheck fix: dream, smd_rpcrouter.c
Message-ID: <20090923073607.GE8565@elf.ucw.cz>
References: <1253631149.3784.29.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253631149.3784.29.camel@ht.satnam>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-09-22 20:22:29, Jaswinder Singh Rajput wrote:
> 
> fix the following 'make includecheck' warning:
> 
>   drivers/staging/dream/smd/smd_rpcrouter.c: asm/byteorder.h is included more than once.
> 
> And <asm/uaccess.h> is not required if we include <linux/uaccess.h>
> as it will be automatically included from <linux/uaccess.h>
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

Acked-by: Pavel Machek <pavel@ucw.cz>


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
