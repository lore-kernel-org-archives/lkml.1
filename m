Return-Path: <linux-kernel-owner+w=401wt.eu-S1751860AbXBFM1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbXBFM1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 07:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbXBFM1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 07:27:31 -0500
Received: from colin.muc.de ([193.149.48.1]:2716 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbXBFM1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 07:27:30 -0500
Date: 6 Feb 2007 13:27:29 +0100
Date: Tue, 6 Feb 2007 13:27:29 +0100
From: Andi Kleen <ak@muc.de>
To: Zachary Amsden <zach@vmware.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 9/11] Panic delay fix
Message-ID: <20070206122729.GC47229@muc.de>
References: <200702060353.l163rUmj000771@zach-dev.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702060353.l163rUmj000771@zach-dev.vmware.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 07:53:30PM -0800, Zachary Amsden wrote:
> Failure to use real-time delay here causes the keyboard to become demonically
> possessed in the event of a kernel crash, with wildly blinking lights and
> unpredictable behavior.  This has resulted in several injuries.

There must be a reason why it wasn't default before. Has this
reason changed?

-Andi

> 
> Signed-off-by: Zachary Amsden <zach@vmware.com>
> 
> diff -r 10fac6d484e2 drivers/input/serio/i8042.c
> --- a/drivers/input/serio/i8042.c	Tue Jan 30 16:44:54 2007 -0800
> +++ b/drivers/input/serio/i8042.c	Tue Jan 30 16:45:00 2007 -0800
> @@ -9,6 +9,7 @@
>   * under the terms of the GNU General Public License version 2 as published by
>   * the Free Software Foundation.
>   */
> +#define USE_REAL_TIME_DELAY
>  
>  #include <linux/delay.h>
>  #include <linux/module.h>
