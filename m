Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbYAETVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbYAETVS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 14:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756254AbYAETVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 14:21:07 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:43371 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756200AbYAETVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 14:21:06 -0500
Date: Sat, 5 Jan 2008 20:20:00 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Al Boldi <a1426z@gawab.com>, Russell King <rmk@arm.linux.org.uk>,
       linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Can ARM use drivers/Kconfig [Was: Kconfig: Source "drivers/usb/gadget/Kconfig" for ARCH=arm]
Message-ID: <20080105192000.GA9553@uranus.ravnborg.org>
References: <200801051546.SAA08953@raad.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801051546.SAA08953@raad.intranet>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2008 at 06:42:52PM +0300, Al Boldi wrote:
> 
> From: David Brownell <david-b@pacbell.net>
> 
> Source "drivers/usb/gadget/Kconfig" for ARCH=arm.
> 
> 
> Cc: David Brownell <david-b@pacbell.net>
> Cc: Greg KH <greg@kroah.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Al Boldi <a1426z@gawab.com>
> 
> ---
> 
> --- 23.a/arch/arm/Kconfig
> +++ 23.b/arch/arm/Kconfig
> @@ -1049,6 +1049,8 @@ source "drivers/hid/Kconfig"
>  
>  source "drivers/usb/Kconfig"
>  
> +source "drivers/usb/gadget/Kconfig"
> +
>  source "drivers/mmc/Kconfig"
>  
>  source "drivers/rtc/Kconfig"

What is preventing ARM from using drivers/Kconfig?
That a better fix IMO.

	Sam
