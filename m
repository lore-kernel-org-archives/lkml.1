Return-Path: <linux-kernel-owner+w=401wt.eu-S1161198AbXCHXbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161198AbXCHXbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 18:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161208AbXCHXbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 18:31:32 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:46419 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161135AbXCHXba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 18:31:30 -0500
X-IronPort-AV: i="4.14,264,1170651600"; 
   d="scan'208"; a="30490216:sNHT22679027"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Russell King" <rmk+lkml@arm.linux.org.uk>
Subject: Re: should RTS init in serial core be tied to CRTSCTS
Date: Thu, 8 Mar 2007 18:32:29 -0500
User-Agent: KMail/1.9.5
Cc: "Oleksiy Kebkal" <kebkal@gmail.com>, "Krzysztof Halasa" <khc@pm.waw.pl>,
       "Mike Frysinger" <vapier.adi@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org
References: <8bd0f97a0703011603m794e00f5x875eb68ad0db05de@mail.gmail.com> <200703081523.39698.rgetz@blackfin.uclinux.org> <20070308204020.GE30023@flint.arm.linux.org.uk>
In-Reply-To: <20070308204020.GE30023@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703081832.29274.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 08 Mar 2007 23:31:28.0344 (UTC) FILETIME=[E5234580:01C761D9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 8 Mar 2007 15:40, Russell King pondered:
> On Thu, Mar 08, 2007 at 03:23:39PM -0500, Robin Getz wrote:
> > Right - We both agree - And setting console=/dev/null in the bootargs
> > still does not help.
>
> Ok, good.
>
> > When the kernel initializes the UART Port, it asserts RTS - which
> > confuses the host it is attached to (in this case, the Linux system
> > is the serial peripheral).
>
> ... which occurs /after/ userspace is up and running, when sysfs is
> available.  So putting it in sysfs is reasonable.

Hmm - maybe I don't understand things then.

Today - RTS gets asserted when serial_core calls uart_startup(), which is 
pretty early in the boot process (unless it is loaded as a module - which I'm 
not doing).

-Robin
