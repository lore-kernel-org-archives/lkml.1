Return-Path: <linux-kernel-owner+w=401wt.eu-S932893AbXHAOLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893AbXHAOLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 10:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760823AbXHAOLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 10:11:34 -0400
Received: from el-out-1112.google.com ([209.85.162.180]:5113 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092AbXHAOLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 10:11:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Vk+M5XR7aAMF24cKHLjAvyFh9vlI8tjZ0qs1YBsGpqsnSgVrWlCGRDchb+ALph+iiQ2QJEtJ5uA3/4UvLJxDUEUIWQw0undybdQi3BJvNM7J48ot61QAAL47zYe5i3s6e3RTe6sIw4+47bM2tujJlak/RQv49p6/RAo9HLjvLHc=
Message-ID: <f24d23310708010711w7cec4718tde8fd33b89fdfcf6@mail.gmail.com>
Date: Wed, 1 Aug 2007 19:41:31 +0530
From: "debian developer" <debiandev@gmail.com>
To: "Andev Debi" <andev.debi@gmail.com>
Subject: Re: Problem - disabling IRQ #20 and others
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <ef8c225f0708010347l2a0a8e4cj4f47a243bba88989@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ef8c225f0708010347l2a0a8e4cj4f47a243bba88989@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/1/07, Andev Debi <andev.debi@gmail.com> wrote:
> Hello,
> Im getting the following error while booting the kernel 2.6.22.1-cfs
>
> Aug  1 09:14:09 localhost kernel: [   30.272161] EXT3 FS on hda8, internal
> journal
> Aug  1 09:14:09 localhost kernel: [   33.572083] device-mapper: ioctl:
> 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
> Aug  1 09:14:09 localhost kernel: [   35.965198] device-mapper: table:
> 253:0: linear: dm-linear: Device lookup failed
> Aug  1 09:14:09 localhost kernel: [   35.965278] device-mapper: ioctl: error
> adding target to table
> Aug  1 09:14:09 localhost kernel: [   35.966396] device-mapper: table:
> 253:0: linear: dm-linear: Device lookup failed
> Aug  1 09:14:09 localhost kernel: [   35.966465] device-mapper: ioctl: error
> adding target to table
> Aug  1 09:14:09 localhost kernel: [   35.967555] device-mapper: table:
> 253:0: linear: dm-linear: Device lookup failed
> Aug  1 09:14:09 localhost kernel: [   35.967625] device-mapper: ioctl: error
> adding target to table
> Aug  1 09:14:09 localhost kernel: [   35.968693] device-mapper: table:
> 253:0: linear: dm-linear: Device lookup failed
> Aug  1 09:14:09 localhost kernel: [   35.968762] device-mapper: ioctl: error
> adding target to table
> Aug  1 09:14:09 localhost kernel: [   35.969822] device-mapper: table:
> 253:0: linear: dm-linear: Device lookup failed
> Aug  1 09:14:09 localhost kernel: [   35.969906] device-mapper: ioctl: error
> adding target to table
> Aug  1 09:14:09 localhost kernel: [   35.970980] device-mapper: table:
> 253:0: linear: dm-linear: Device lookup failed
> Aug  1 09:14:09 localhost kernel: [   35.971049] device-mapper: ioctl: error
> adding target to table
> Aug  1 09:14:09 localhost kernel: [   35.972166] device-mapper: table:
> 253:0: linear: dm-linear: Device lookup failed
> Aug  1 09:14:09 localhost kernel: [   35.972235] device-mapper: ioctl: error
> adding target to table
> Aug  1 09:14:09 localhost kernel: [   35.973365] device-mapper: table:
> 253:0: linear: dm-linear: Device lookup failed
> Aug  1 09:14:09 localhost kernel: [   35.973435] device-mapper: ioctl: error
> adding target to table
> Aug  1 09:14:09 localhost kernel: [   35.974552] device-mapper: table:
> 253:0: linear: dm-linear: Device lookup failed
> Aug  1 09:14:09 localhost kernel: [   35.974622] device-mapper: ioctl: error
> adding target to table
> Aug  1 09:14:09 localhost kernel: [   35.975480] device-mapper: table:
> 253:0: linear: dm-linear: Device lookup failed
> Aug  1 09:14:09 localhost kernel: [   35.975548] device-mapper: ioctl: error
> adding target to table
> Aug  1 09:14:09 localhost kernel: [   35.975872] device-mapper: table:
> 253:0: linear: dm-linear: Device lookup failed
> Aug  1 09:14:09 localhost kernel: [   35.975954] device-mapper: ioctl: error
> adding target to table
> Aug  1 09:14:09 localhost kernel: [   35.977964] device-mapper: table:
> 253:0: linear: dm-linear: Device lookup failed
> Aug  1 09:14:09 localhost kernel: [   35.978034] device-mapper: ioctl: error
> adding target to table
> Aug  1 09:14:09 localhost kernel: [   35.978552] device-mapper: table:
> 253:0: linear: dm-linear: Device lookup failed
> Aug  1 09:14:09 localhost kernel: [   35.978620] device-mapper: ioctl: error
> adding target to table
> Aug  1 09:14:09 localhost kernel: [   35.978901] device-mapper: table:
> 253:0: linear: dm-linear: Device lookup failed
> Aug  1 09:14:09 localhost kernel: [   35.978967] device-mapper: ioctl: error
> adding target to table
> Aug  1 09:14:09 localhost kernel: [   35.981040] device-mapper: table:
> 253:0: linear: dm-linear: Device lookup failed
> Aug  1 09:14:09 localhost kernel: [   35.981109] device-mapper: ioctl: error
> adding target to table
> Aug  1 09:14:09 localhost kernel: [   35.981433] device-mapper: table:
> 253:0: linear: dm-linear: Device lookup failed
> Aug  1 09:14:09 localhost kernel: [   35.981499] device-mapper: ioctl: error
> adding target to table
> Aug  1 09:14:09 localhost kernel: [   35.981764] device-mapper: table:
> 253:0: linear: dm-linear: Device lookup failed
> Aug  1 09:14:09 localhost kernel: [   35.981831] device-mapper: ioctl: error
> adding target to table
> Aug  1 09:14:09 localhost kernel: [   35.984417] device-mapper: table:
> 253:0: linear: dm-linear: Device lookup failed
> Aug  1 09:14:09 localhost kernel: [   35.984486] device-mapper: ioctl: error
> adding target to table
> Aug  1 09:14:09 localhost kernel: [   35.985575] device-mapper: table:
> 253:0: linear: dm-linear: Device lookup failed
> Aug  1 09:14:09 localhost kernel: [   35.985644] device-mapper: ioctl: error
> adding target to table
> Aug  1 09:14:09 localhost kernel: [   35.986116] device-mapper: table:
> 253:0: linear: dm-linear: Device lookup failed
> Aug  1 09:14:09 localhost kernel: [   35.986183] device-mapper: ioctl: error
> adding target to table
> Aug  1 09:14:09 localhost kernel: [   35.986475] device-mapper: table:
> 253:0: linear: dm-linear: Device lookup failed
> Aug  1 09:14:09 localhost kernel: [   35.986542] device-mapper: ioctl: error
> adding target to table
> Aug  1 09:14:09 localhost kernel: [   35.986814] device-mapper: table:
> 253:0: linear: dm-linear: Device lookup failed
> Aug  1 09:14:09 localhost kernel: [   35.986885] device-mapper: ioctl: error
> adding target to table
> Aug  1 09:14:09 localhost kernel: [   35.989342] device-mapper: table:
> 253:0: linear: dm-linear: Device lookup failed
> Aug  1 09:14:09 localhost kernel: [   35.989412] device-mapper: ioctl: error
> adding target to table
> Aug  1 09:14:09 localhost kernel: [   35.989692] device-mapper: table:
> 253:0: linear: dm-linear: Device lookup failed
> Aug  1 09:14:09 localhost kernel: [   35.989758] device-mapper: ioctl: error
> adding target to table
> .......................
> .......................
> Aug  1 09:14:17 localhost kernel: [   63.106550] irq 20: nobody cared (try
> booting with the "irqpoll" option)
> Aug  1 09:14:17 localhost kernel: [   63.106574]  [__report_bad_irq+36/128]
> __report_bad_irq+0x24/0x80
> Aug  1 09:14:17 localhost kernel: [   63.106596]  [note_interrupt+485/560]
> note_interrupt+0x1e5/0x230
> Aug  1 09:14:17 localhost kernel: [   63.106619]  [handle_IRQ_event+37/80]
> handle_IRQ_event+0x25/0x50
> Aug  1 09:14:17 localhost kernel: [   63.106634]
> [handle_fasteoi_irq+141/160] handle_fasteoi_irq+0x8d/0xa0
> Aug  1 09:14:17 localhost kernel: [   63.106643]  [do_IRQ+62/128]
> do_IRQ+0x3e/0x80
> Aug  1 09:14:17 localhost kernel: [   63.106665]  [common_interrupt+35/40]
> common_interrupt+0x23/0x28
> Aug  1 09:14:17 localhost kernel: [   63.106674]  [default_idle+0/64]
> default_idle+0x0/0x40
> Aug  1 09:14:17 localhost kernel: [   63.106696]  [default_idle+42/64]
> default_idle+0x2a/0x40
> Aug  1 09:14:17 localhost kernel: [   63.106704]  [cpu_idle+72/112]
> cpu_idle+0x48/0x70
> Aug  1 09:14:17 localhost kernel: [   63.106707]  [start_kernel+559/704]
> start_kernel+0x22f/0x2c0
> Aug  1 09:14:17 localhost kernel: [   63.106715]  [unknown_bootoption+0/592]
> unknown_bootoption+0x0/0x250
> Aug  1 09:14:17 localhost kernel: [   63.106735]  =======================
> Aug  1 09:14:17 localhost kernel: [   63.106736] handlers:
> Aug  1 09:14:17 localhost kernel: [   63.106738] [<dcc13080>]
> (via_driver_irq_handler+0x0/0x1b0 [via])
> Aug  1 09:14:17 localhost kernel: [   63.106747] Disabling IRQ #20
>

Are there any non-working devices on your system?

> Later I repeated the booting with "irqpoll" option, then it was showing both
> the above errors and another error as
