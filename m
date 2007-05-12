Return-Path: <linux-kernel-owner+w=401wt.eu-S1760150AbXELVM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbXELVM4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 17:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754696AbXELVMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 17:12:49 -0400
Received: from smtp.bulldogdsl.com ([212.158.248.8]:1082 "EHLO
	mcr-smtp-002.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754252AbXELVMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 17:12:49 -0400
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [announce] Intel announces the PowerTOP utility for Linux
Date: Sat, 12 May 2007 22:12:43 +0100
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
References: <4644F726.1050806@linux.intel.com>
In-Reply-To: <4644F726.1050806@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705122212.43653.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 May 2007 00:07:18 Arjan van de Ven wrote:
> What's eating the battery life of my laptop? Why isn't it many more
> hours? Which software component causes the most power to be burned?
> These are important questions without a good answer... until now.

This is a really great tool and presents a very intuitive alternative to the 
timer stats file..

On a Core 2 Duo Macbook, Linux always gets around 3.2h battery, OS X about 
4.2h. This tool has identified that uhci_hcd is where 75% of the ticks are 
going when X is not loaded. Unloading uhci_hcd drops the battery life back to 
around 4.2h, but I lose the keyboard.

Is there any way to find out what USB driver is causing usb_uhci to be this 
busy?

(BTW, the link to Keith's patch for dhcdbd seems to be broken on your 
homepage.)

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
