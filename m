Return-Path: <linux-kernel-owner+w=401wt.eu-S1752897AbYLNGnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbYLNGnZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 01:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbYLNGnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 01:43:14 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:20101 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbYLNGnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 01:43:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Ecgh+0lZQWKFREEWqPeULXVfwWnfvVe3JQ38Dy2LbD7S1IrCpkaHuAhlaE2W+EKOLD
         9Ji9mICXH9nkZCta5224NX142XaITvAOWeoeDi9ex+vRzJS6cF/m02rvwNSgwDYycvO3
         gbcezs9xKj/ySeNVwMWod3hd8iGKG/kQaqHmY=
Message-ID: <4944AAFD.1060105@gmail.com>
Date: Sat, 13 Dec 2008 22:43:09 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: suspend/resume fails on second attempt in LNXVIDEO:00
References: <gi247o$iog$1@ger.gmane.org>
In-Reply-To: <gi247o$iog$1@ger.gmane.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian J. Murrell wrote:
> I'm trying to debug a resume problem on a compaq presario C700 laptop on 
> the Ubuntu 2.6.24-22-generic kernel.
>
> I've used the /sys/power/pm_trace facility to debug the problem to the
> following:
>
> [   31.212062]   Magic number: 0:716:374
> [   31.212115]   hash matches /build/buildd/linux-2.6.24/drivers/base/power/main.c:97
> [   31.212255]   hash matches device LNXVIDEO:00
>
> Not sure where to go from here though.  Devices in this machine are:
>
> 00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory Controller Hub (rev 03)
> 00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 03)
> 00:02.1 Display controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 03)
> 00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 03)
> 00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 03)
> 00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 03)
> 00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 03)
> 00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #3 (rev 03)
> 00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 03)
> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3)
> 00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface Controller (rev 03)
> 00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE Controller (rev 03)
> 00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA AHCI Controller (rev 03)
> 00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 03)
> 01:00.0 Ethernet controller: Atheros Communications Inc. AR242x 802.11abg Wireless PCI Express Adapter (rev 01)
> 02:01.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
>
> These symptoms mirror a lot of other reports with this machine in that 
> the first suspend/resume cycle works but a second attempts (apparently) 
> suspends fine but fails on resume.  The backlight on the video does not 
> come back and neither does the wireless connection, so I'm not positive 
> the problems are purely video related.
>
> How can I proceed from here to further debug what kind of workarounds or
> solutions I might be able to use to get reliable suspend/resume 
> functionality?
>
> Thanx,
> b.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>   
not too sure what the situation is for you, but
if  you're deciding to stay with 2.6.24.* then
look through the commits to see if this has been resolved.
if not then load the latest git to see if this has been committed
for the fix. if it's just debugging then hmm.. maybe ssh
(but you don't have intranet upon wakeup); maybe usb
or some other hard wired mechanism?

regards;

Justin P. Mattock



 

