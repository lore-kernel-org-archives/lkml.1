Return-Path: <linux-kernel-owner+w=401wt.eu-S933605AbXCOUHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605AbXCOUHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 16:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933638AbXCOUHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 16:07:22 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:36537 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933605AbXCOUHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 16:07:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dvnatilZjkQQv3/sB2cRE5HCiAuHN96RGvBM2STtNI+qw+k/o7bkzATL7hiPVxv1LVo6LH4aGG8Nt5j9xhC6i6HlE9vB/o+LXgFgEypZ55quvlC4TzeNcmxr2Sj+7bADKjvNnsiHmto93uvMQnPh/2EC4mENs5YD4nK4A8S/WMk=
Message-ID: <d120d5000703151307w110c5258q6a4c53381e71e89c@mail.gmail.com>
Date: Thu, 15 Mar 2007 16:07:18 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Subject: Re: [linux-usb-devel] USB Keyboard
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
       "Linux kernel" <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net
In-Reply-To: <Pine.LNX.4.61.0703151541430.4459@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.44L0.0703151506010.2482-100000@iolanthe.rowland.org>
	 <Pine.LNX.4.61.0703151541430.4459@chaos.analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/15/07, linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
> echo "Loading uhci-hcd.ko module"
> insmod /lib/uhci-hcd.ko
> echo "Loading ehci-hcd.ko module"
> insmod /lib/ehci-hcd.ko

I don't see you loading OHCI and I thought AMD boxes used that flavor.

> echo "Loading usbhid.ko module"
> insmod /lib/usbhid.ko
> echo "Loading usbkbd.ko module"
> insmod /lib/usbkbd.ko
> echo "sleeping for a few seconds"
> sleep 2
> echo "Mounting root filesystem"
> /bin/findroot
> mount -o defaults --ro -t iso9660 /dev/root /sysroot
> pivot_root /sysroot /sysroot/initrd
> umount /initrd/proc
> exec /sbin/init
>

-- 
Dmitry
