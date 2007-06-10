Return-Path: <linux-kernel-owner+w=401wt.eu-S1761028AbXFJEc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761028AbXFJEc1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 00:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754378AbXFJEcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 00:32:19 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:55644 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbXFJEcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 00:32:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BQWR8KuNLr2oAAd7ZHbOfEZna6je6/qa94wOpdwviPErbyFd/lZ1Q94vV32T6F6mFdqvoPGyHmm2hJ+RhJwnt0fGEJlE6lpCpOXOu/iqF/ehwQfz1Ta2/CyYzHLFnU7KIM/+q1bRnV9oJsCkClakqmsmzXqg2L9pXl8tuUZEUY4=
Message-ID: <21d7e9970706092132g4a342348j3c252b0a865f184b@mail.gmail.com>
Date: Sun, 10 Jun 2007 14:32:17 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "John Richard Moser" <nigelenki@comcast.net>,
       "=?ISO-8859-1?Q?Thomas_Hellstr=F6m?=" <thomas@tungstengraphics.com>
Subject: Re: via_drm bug
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <466B6ADC.7080908@comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466B6ADC.7080908@comcast.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/10/07, John Richard Moser <nigelenki@comcast.net> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> This has been an on-going issue for.... I don't know how long.  I
> reported it a while ago but it's still in 2.6.22.
>
> Here's another error log.  Loaded the Via driver in Xorg with kernel
> 2.6.22 on Ubuntu, got the following in dmesg.  The [drm:via_mem_alloc]
> error may be the problem.  This is on a 32-bit kernel.
>

I've cc'ed Thomas to see if he can help out, he knows the via drm ..

Dave.

> See also:
>
> https://bugs.launchpad.net/ubuntu/+source/xserver-xorg-video-via/+bug/72630
>
>
>
> [264565.164000] [drm] Initialized via 2.11.1 20070202 on minor 0
> [264565.168000] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level,
> low) -> IRQ 21
> [264565.168000] [drm] Initialized via 2.11.1 20070202 on minor 1
> [264565.184000] agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
> [264565.184000] agpgart: Xorg tried to set rate=x12. Setting to AGP3 x8
> mode.
> [264565.184000] agpgart: Putting AGP V3 device at 0000:00:00.0 into 8x mode
> [264565.184000] agpgart: Putting AGP V3 device at 0000:01:00.0 into 8x mode
> [264565.192000] [drm:via_mem_alloc] *ERROR* Attempt to allocate from
> uninitialized memory manager.
> [264565.296000] powernow-k8: error - out of sync, fix 0x2 0xa, vid 0x0 0x0
> [264565.296000] powernow-k8: ph2 null fid transition 0xa
> [264565.692000] irq 21: nobody cared (try booting with the "irqpoll" option)
> [264565.692000]  [<c015bcc4>] __report_bad_irq+0x24/0x80
> [264565.692000]  [<c015bf82>] note_interrupt+0x262/0x2a0
> [264565.692000]  [<c015b1e0>] handle_IRQ_event+0x30/0x60
> [264565.692000]  [<c015c96b>] handle_fasteoi_irq+0xbb/0xf0
> [264565.692000]  [<c0106b1b>] do_IRQ+0x3b/0x70
> [264565.692000]  [<c0118735>] smp_apic_timer_interrupt+0x55/0x80
> [264565.692000]  [<c0102e00>] default_idle+0x0/0x60
> [264565.692000]  [<c0105223>] common_interrupt+0x23/0x30
> [264565.692000]  [<c0102e00>] default_idle+0x0/0x60
> [264565.692000]  [<c011db72>] native_safe_halt+0x2/0x10
> [264565.692000]  [<c0102e3c>] default_idle+0x3c/0x60
> [264565.692000]  [<c0102413>] cpu_idle+0x53/0xe0
> [264565.692000]  [<c03dfa7f>] start_kernel+0x31f/0x3b0
> [264565.692000]  [<c03df1f0>] unknown_bootoption+0x0/0x260
> [264565.692000]  =======================
> [264565.692000] handlers:
> [264565.692000] [<f8eb6480>] (via_driver_irq_handler+0x0/0x1d0 [via])
> [264565.692000] Disabling IRQ #21
>
>
>
> Device:
>
> 01:00.0 VGA compatible controller: VIA Technologies, Inc. S3 Unichrome
> Pro VGA Adapter (rev 01)
>
>
> lshw segment:
>
>            *-display
>                 description: VGA compatible controller
>                 product: S3 Unichrome Pro VGA Adapter
>                 vendor: VIA Technologies, Inc.
>                 physical id: 0
>                 bus info: pci@01:00.0
>                 version: 01
>                 size: 64MB
>                 width: 32 bits
>                 clock: 66MHz
>                 capabilities: vga bus_master cap_list
>                 configuration: latency=32 mingnt=2
>                 resources: iomemory:e4000000-e7ffffff
> iomemory:e8000000-e8ffffff irq:21
>
>
> - --
>     We will enslave their women, eat their children and rape their
>     cattle!
>              -- Bosc, Evil alien overlord from the fifth dimension
> LiveCD Creator Poll:  http://ubuntuforums.org/showthread.php?t=435562
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.6 (GNU/Linux)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org
>
> iQIVAwUBRmtq2ws1xW0HCTEFAQKthhAAmEDCkQGl5tEfioxZE67/a1EkVKQisIwk
> YWKKZ/+5uQo/wo1V/HWIekRICByYVjuK3vqnJmXo9VEk37L/ZRQgcDDiMyG5lRwR
> UhtYFVEMkPyr923EKGXyQCjdNaYDHWHz4VWOtf1mpyPMP3WVByvOJcGWikv/wWcl
> BLb37+tk9Wv7846zwoTwREStZHJbhoSac+VSidgV3koIjeeOCqFwicNP+6ycOSbE
> PnBQ/sjsbagw7DdweDR6QvDzxtnS/KP4adGutXGJUQYN1s4R5YDIDF7Qk1M1hNN7
> 7IH7KNwNXwzKq3v6jCcYrprOthBrB7Xho2s8nM+fT3Kzwpj+UTy/wvesEQQNbDSD
> jTVGFa4qjQIdgf4G/n88Wv4Pm2yHC1dRyPrrRz8TX2rv4A3cqlC+REYfVyHhS9Uh
> 2gNUOctawvAM1rL2peG9SDvsEJNYIzoV/jL61zit3Jpkevc34Aq1wrxj+cyxchJI
> 7zUtshxGCOOIiEwgJ9u/5E0T128hXGIX9Nm3Cb6bdj5aVRv+kso/bpMGGcn5+opa
> JdUYg9avJMbJtlmfWtz7EEACLB8DeUTbCFKZ2ctoqCm4UKkyex2uX+sAAI1hbjpZ
> oPYcXEs4bcb8BlZpntykybjlJUtGOeTlCyULeWATNHDF+txgTnpkp7U79Z73EXIL
> vI9KkUJ2qho=
> =hmgi
> -----END PGP SIGNATURE-----
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
