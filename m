Return-Path: <linux-kernel-owner+w=401wt.eu-S1760853AbXENUmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760853AbXENUmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758956AbXENUmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:42:24 -0400
Received: from mcr-smtp-001.bulldogdsl.com ([212.158.248.7]:4517 "EHLO
	mcr-smtp-001.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758409AbXENUmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:42:22 -0400
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [announce] Intel announces the PowerTOP utility for Linux
Date: Mon, 14 May 2007 21:42:07 +0100
User-Agent: KMail/1.9.6
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
References: <4644F726.1050806@linux.intel.com> <200705122212.43653.s0348365@sms.ed.ac.uk> <Pine.LNX.4.61.0705142221440.9570@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705142221440.9570@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705142142.07983.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 May 2007 21:22:50 Jan Engelhardt wrote:
> On May 12 2007 22:12, Alistair John Strachan wrote:
> >On Saturday 12 May 2007 00:07:18 Arjan van de Ven wrote:
> >> What's eating the battery life of my laptop? Why isn't it many more
> >> hours? Which software component causes the most power to be burned?
> >> These are important questions without a good answer... until now.
> >
> >This is a really great tool and presents a very intuitive alternative to
> > the timer stats file..
> >
> >On a Core 2 Duo Macbook, Linux always gets around 3.2h battery, OS X about
> >4.2h. This tool has identified that uhci_hcd is where 75% of the ticks are
> >going when X is not loaded. Unloading uhci_hcd drops the battery life back
> > to around 4.2h, but I lose the keyboard.
> >
> >Is there any way to find out what USB driver is causing usb_uhci to be
> > this busy?
>
> At its worst, it _is_ the USB chip that draws the power when it is active
> (when uhci_hcd is loaded); does not need to be usbhid or so.

This is certainly true, and to a significant extent it _was_ the uhci_hcd, but 
it turns out the main contributor to HZ here were the appletouch and hci_usb 
drivers. Disabling both drops the ticks down from about 850 to 150.

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
