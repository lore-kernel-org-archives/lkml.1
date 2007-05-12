Return-Path: <linux-kernel-owner+w=401wt.eu-S1759608AbXELVr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759608AbXELVr4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 17:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbXELVrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 17:47:49 -0400
Received: from mcr-smtp-001.bulldogdsl.com ([212.158.248.7]:2335 "EHLO
	mcr-smtp-001.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754183AbXELVrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 17:47:49 -0400
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: converting appletouch to usb autosuspend...
Date: Sat, 12 May 2007 22:47:44 +0100
User-Agent: KMail/1.9.6
Cc: linux-usb-devel@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>, maxk@qualcomm.com
References: <1178995886.4168.10.camel@localhost>
In-Reply-To: <1178995886.4168.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705122247.44795.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 May 2007 19:51:26 Soeren Sonnenburg wrote:
> Dear all,
>
> I've realized using the great powertop ( http://www.linuxpowertop.org/ )
> that loading the appletouch driver (and touching it once) makes consumes
> about 0.3 W even when not touching the pad. As rmmod'ing appletouch
> fixes this I wonder why the driver does not do this alone. So my
> question is what does one have to do to convert a driver (such as
> appletouch) to make use of usb autosuspend except for
>
>  .supports_autosuspend = 1
>
> ...
>
> While we are at it usb related powerhogs on this macbook pro are
> uhci_hcd (usb keyboard) and usb_hcd_poll_rh_status (rh_timer_func)
> too...

I've found that hci_usb also hogs power on the Macbook; blacklisting this 
module cuts down HZ considerably. I also found appletouch consumed ticks, 
just as you did.

uhci_hcd then drops to noise; my Macbook's sitting on 10W with the backlight 
on minimum, which is about what it can manage in OS X on maximum life 
settings.

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
