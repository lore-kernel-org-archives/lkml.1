Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbZAARdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbZAARdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 12:33:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755904AbZAARdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 12:33:44 -0500
Received: from blaine.gmane.org ([80.91.229.8]:51102 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754755AbZAARdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 12:33:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=lrU7GrqXYiZNoY0S+9O3tTD8DM1KuXGKL4HBIgsbxYTxKR4a7QyWYPYQHlTN0PV19W
         a8b5J/63lkKhd3vp1h/uifJ270wT68qk6F0IPnvk4RgZPRl+huYIpOu+k5VQGWOOLdFa
         nw8kxGHQ0XDmRfJBjVnP9FuDwuLn9RgsKSr6Y=
Message-ID: <495CFE38.6070603@gmail.com>
Date: Thu, 01 Jan 2009 22:32:40 +0500
From: "Alexander E. Patrakov" <patrakov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ru-RU; rv:1.8.1.19) Gecko/20081226 SeaMonkey/1.1.14
MIME-Version: 1.0
To: public-gregkh-l3A5Bk7waGM@hugh.gmane.org,
       public-linux-usb-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org,
       public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org,
       public-elliot.li.tech-Re5JQEeQqe8AvxtiuMwx3w@hugh.gmane.org
Subject: Re: Enable CONFIG_USB_SUSPEND by default or some mobile HD can't
 be   unplugged safely
References: <20090101160343.GA4278@thyme.bj.intel.com>
In-Reply-To: <20090101160343.GA4278@thyme.bj.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Yan Li wrote:
> Hello List,
> 
> By default CONFIG_USB_SUSPEND is not enabled and today I got bite by
> this when I got a new WDC My Book hard drive. I have no way to unplug
> it safely, according to it's manual, with a kernel that doesn't have
> CONFIG_USB_SUSPEND=y.
> 
> On it's manual read "you should unplug and remove the device only when
> the light is off." On Linux unmounting it won't turn it's light off
> and I can feel it's motor is still running.  The only way to unplug it
> properly on a Linux system, as to my knowledge, is to echo `suspend'
> to `/sys/bus/usb/devices/$DEV/power/level'. And one has to have
> CONFIG_USB_SUSPEND=y to do this.
> 
> On Windows and Mac OS, `safely remove this device' function effectly
> turns it into `suspend' mode, and it's light off.

You have obviously tested only Windows XP, because Vista doesn't cut the 
power for at least some USB devices. And congratulations for obtaining a 
Vista-incompatible hard drive (of course, joking).

BTW, does the "eject /dev/$DEV" command help?

-- 
Alexander E. Patrakov

