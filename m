Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbXENN2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbXENN2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 09:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbXENN2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 09:28:04 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:15876 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbXENN2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 09:28:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=Jy8qcmVIN+HJrAtSic3feIpEpCpU9w5C6y7dFLejMLphRAV0gbWDn9o8O7iSwht7FQgIwkuT1T9qbjVou2kii1QWem/vveGH6evbjaNmMEnbqS7pjDDg9Ljb3oOlHz9FD+mExdyaznHI0hZNxbnymD2+fJHNYU6iXU+tCyhxLZ8=
Message-ID: <5486cca80705140628w5ff43ebdqf6a5413203226d5@mail.gmail.com>
Date: Mon, 14 May 2007 15:28:00 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: Linux 2.6.22-rc1
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070514141437.631fcfd1@hyperion.delvare>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_130553_8188191.1179149280744"
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
	 <5486cca80705131010h2011487dnc948a3c57ce6decc@mail.gmail.com>
	 <alpine.LFD.0.98.0705131046400.6739@woody.linux-foundation.org>
	 <5486cca80705131150u313eeb43i30bf040e160ac419@mail.gmail.com>
	 <20070514081022.7fcee97f@hyperion.delvare>
	 <5486cca80705140134r318296b8k37ad6f4562b4b535@mail.gmail.com>
	 <20070514141437.631fcfd1@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_130553_8188191.1179149280744
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Jean,

2007/5/14, Jean Delvare <khali@linux-fr.org>:
[cut]
> This is a rather bad idea to build the abituguru and hdaps drivers into
> your kernel if you don't have these devices. Especially abituguru, as
> it does arbitrary port probing.

My bad. I have an abit motherboard and in doubt I selected the driver
(and then leaved selected since all worked on previous kernels). I've
disabled them and the problem persist.

> > > > The first column of lsmod list the same modules in both kernels. Th=
e
> > > > diff-ed dmesg is attached.
> > >
> > > Please provide the output of lsmod.
> > >
> > > If you are using one of the following drivers: lm78, smsc47b397,
> > > smsc47m1, w83627hf or w83781d, you need lm_sensors >=3D 2.10.1
> > > (libsensors.so.3.1.1 or later).
> >
> > I've attached the lsmod for 2.6.22-rc.
>
> You didn't.
>

:) Right, sorry. Now it is.

> > I'm not using any of the listed drivers.
>
> How strange, why are they loaded then?

My reply refers to your list of drivers that require a certain version
of lm-sensors.

> > However the lm-sensors package is version 2.10.1-3 and
> > libsensors.so.3.1.1 is on my system too (package libsensors3).
>
> Can you please share the output of "sensors" under both kernels 2.6.21.1
> and 2.6.22-rc1.

Sure. On 2.6.21.1:

via686a-isa-6000
Adapter: ISA adapter
CPU core:  +1.63 V  (min =3D  +0.06 V, max =3D  +3.10 V)
+2.5V:     +2.45 V  (min =3D  +0.06 V, max =3D  +3.10 V)
I/O:       +3.52 V  (min =3D  +3.12 V, max =3D  +3.45 V)   ALARM
+5V:       +5.05 V  (min =3D  +4.73 V, max =3D  +5.20 V)
+12V:     +12.30 V  (min =3D +11.35 V, max =3D +12.48 V)
CPU Fan:     0 RPM  (min =3D 42187 RPM, div =3D 2)
P/S Fan:  2657 RPM  (min =3D 42187 RPM, div =3D 2)          ALARM
SYS Temp:  +40.9=B0C  (high =3D  +146=B0C, hyst =3D   -71=B0C)
CPU Temp:  +43.3=B0C  (high =3D  +146=B0C, hyst =3D   -71=B0C)
SBr Temp:  +24.9=B0C  (high =3D   -63=B0C, hyst =3D   -71=B0C)   ALARM

while on 2.6.22-rc1:

via686a-i2c-9191-6000
 ERROR: Can't get adapter or algorithm?!?
CPU core:  +1.65 V  (min =3D  +0.06 V, max =3D  +3.10 V)
+2.5V:     +2.45 V  (min =3D  +0.06 V, max =3D  +3.10 V)
I/O:       +3.52 V  (min =3D  +3.12 V, max =3D  +3.45 V)   ALARM
+5V:       +5.08 V  (min =3D  +4.73 V, max =3D  +5.20 V)
+12V:     +12.24 V  (min =3D +11.35 V, max =3D +12.48 V)
CPU Fan:     0 RPM  (min =3D 42187 RPM, div =3D 2)
P/S Fan:     0 RPM  (min =3D 42187 RPM, div =3D 2)          ALARM
SYS Temp:  +41.3=B0C  (high =3D  +146=B0C, hyst =3D   -71=B0C)
CPU Temp:  +41.8=B0C  (high =3D  +146=B0C, hyst =3D   -71=B0C)
SBr Temp:  +24.9=B0C  (high =3D   -63=B0C, hyst =3D   -71=B0C)   ALARM

In both kernels I have set:

     I2C Algorithms  --->
      <M> I2C PCF 8584 interfaces
      <M> I2C PCA 9564 interfaces

> I would also be interested in a diff of /proc/ioports between 2.6.21.1
> and 2.6.22-rc1.
>

The diff is empty.

> --
> Jean Delvare


    ~ Antonio

------=_Part_130553_8188191.1179149280744
Content-Type: application/x-gzip; name=lsmod.2.6.22-rc1.gz
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f1oyv6xb
Content-Disposition: attachment; filename="lsmod.2.6.22-rc1.gz"

H4sICK5iSEYAA2xzbW9kLjIuNi4yMi1yYzEAjVZLlpswENxzCh2Ahf5Ih8gqL2seBs1Yb8AifDx2
Th99wIDEJKMlKlV3VUvd/DDN3CqQrJ/6j/36a1QNuDyzi769dVPZ6bE+oASnAgAEMt3feUqCoZTM
fhcgm65q6Ko2RiDIIAUAguytuqUEdhGGA2CoGmUSDMIICQvAIGuG7oygwIJhywMCQXaZpynlAYAJ
Cn2gfjC1GkczRJEIk9yJXaRkrTH9STyLK7AnGm9NqboZwQ9Ujs/bdF0QHFG6BzwOuzZVjJmPlBD4
E6P6Xd710OlGb8l7E14nHhHcYd331X8mhDiBz+PlqptEEbY1CNac7ToAhdyHDwR74XtjcEE4dKX6
Wlczd91zz8zl5qUDmHE8RBaC0wPgYIszGy9lPXpxV7dpBUDhrkdkbb6LmO/PrkSxCZRJd5VlZGr+
Fe+rJvlB/Jdx81SAT2WoPmPNSFL3aM41LcanmqpaFmVtGrW9cUkJF9FNzDzuMo+xAUi6WxKwG5en
7usurhwRcvcKOv1QwxGCqC9M4FsIVrI4NJcM4VXwXuCWRx7TeMfVXde77seZuywivaD5SVFjI79X
vnxXM5/HpDsVtxoJC34mZz1vdQQrqndVVm1rdm25oK5N4eTsemaedFt26uAhoWx/5kSlP3r9bFTc
8njhWsn/jsYFc4sS4VQi9p0XE5u9s3fv6D+Knh/u2bqzVc9fhfxVkfwlONONKutUAqHCTT83Meqx
/xhShZgsw61uBnMynAgR2PfNECF7a03fPxMYw4KHQBrX1pXKTqgjoiAiNDm7yQWvYgZkXxsPj83M
t6Y2QzzymXwNEB9FjwkJIDA8yCVINkx1gvHZQBaCzddal9fEOoIhCgCBiJyMiQkwIii0/U7reNMv
yqhPdyHI1N3W7yyVwuEYcKPtRDUiUELoXlqYXPmacVZ1TflRlNV7dN9Dh7B/PHbnvRqmJHXuBxIG
9m8k30iyv1KMB01oCQAA
------=_Part_130553_8188191.1179149280744--
