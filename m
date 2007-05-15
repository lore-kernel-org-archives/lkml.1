Return-Path: <linux-kernel-owner+w=401wt.eu-S934482AbXEOMFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934482AbXEOMFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 08:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758527AbXEOMFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 08:05:43 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:33499 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758357AbXEOMFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 08:05:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OgZOTV1dojihKL4hFPSWibK7KUPmT5xZ9afjjJ9aCDW12p6RJ1Fbt1ZoZx1aYJDC0C07otU+7jpXCv7v8XMGkhTj0NrO6O800+kSxvsT8G2n1XsGGsvuVkgUm5RkZryetHwHnp6lFuLHV75BVx8mcROc/gzhJzqrGolLuy9jdQQ=
Message-ID: <35fbaa3e0705150505i5f85f1a0rade73340cd60f690@mail.gmail.com>
Date: Tue, 15 May 2007 15:05:41 +0300
From: "Vitaliy Ivanov" <vitalivanov@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: USB adutux device number
In-Reply-To: <35fbaa3e0705140910s19feac4bnd71a80f25dc4753c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <35fbaa3e0705140910s19feac4bnd71a80f25dc4753c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Did any of USB fellows has a chance to look at this issue?

It can be critical to customers as this 67 minor number is listed in
the driver code only and not all of them going through the code.

-- Vitaliy


On 5/14/07, Vitaliy Ivanov <vitalivanov@gmail.com> wrote:
> Hello,
>
> I'm not sure if it's correct place to deal with the issue.
>
> In Documentation/devices.txt there is no info about adutux driver that
> is included in the kernel:
> ...
>                  65 = /dev/usb/usblcd   USBLCD Interface (info@usblcd.de)
>                  66 = /dev/usb/cpad0    Synaptics cPad (mouse/LCD)
>                  96 = /dev/usb/hiddev0  1st USB HID device
>                     ...
> ...
>
> The driver itself includes the following (drivers/usb/misc/adutux.c):
>
> #ifdef CONFIG_USB_DYNAMIC_MINORS
> #define ADU_MINOR_BASE  0
> #else
> #define ADU_MINOR_BASE  67
> #endif
>
> We need to update Documentation/devices.txt with this information. The
> number of devices is 16.
>
> I found an old mail tread for this:
> http://www.uwsg.iu.edu/hypermail/linux/kernel/0609.3/2173.html
> But I don't see anything related to adu devices in devices.txt at all.
>
> Please let me know what is the reason of this. If needed I will create
> a patch for this.
>
> -- V
>
