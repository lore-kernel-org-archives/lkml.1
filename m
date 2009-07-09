Return-Path: <linux-kernel-owner+w=401wt.eu-S1754996AbZGJMGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbZGJMGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 08:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755054AbZGJMGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 08:06:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53616 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047AbZGJMGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 08:06:07 -0400
Date: Fri, 10 Jul 2009 01:20:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
       charles.f.johnson@intel.com
Subject: Re: [PATCH] Restricted Access Region Register driver for Intel MID
	devices
Message-ID: <20090709232039.GE1469@ucw.cz>
References: <1247083212-17331-1-git-send-email-mark.a.allyn@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247083212-17331-1-git-send-email-mark.a.allyn@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-07-08 13:00:12, Mark Allyn wrote:
> This is the device driver for the Restricted Access Region registers on the
> Intel MID device.
> 
> Restricted Access Regions are areas of memory that are not accessable to the
> i86 processor.
> 
> This driver is used by other device drivers to obtain the start and end 
> addresses of the Restricted Access Regions.
> 
> This driver is not used by any user space applications.
> 
> This patch is applied against 2.6.31
> 
> Signed off my Mark Allyn <mark.a.allyn@intel.com>
> ---
>  drivers/Kconfig                     |    2 +
>  drivers/Makefile                    |    1 +
>  drivers/rar_register/Kconfig        |   17 +

rar_register is really bad name. It is simultaneously too long and too
abberviated.

> +menu "RAR Register Driver"
> +#
> +# The new 8250/16550 serial drivers
> +config RAR_REGISTER
> +	tristate "Restricted Access Region Register Driver"
> +	depends on MRST

Serial driver?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
