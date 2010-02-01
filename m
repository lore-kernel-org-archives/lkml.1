Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab0BAUqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 15:46:31 -0500
Received: from mail.gmx.net ([213.165.64.20]:39635 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751484Ab0BAUqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 15:46:30 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/reZ5C4APrXcG8H2fiZltl7QSLlT23x2YjGWuvEV
	Kd/IEtQEYPfjP6
Date: Mon, 1 Feb 2010 21:46:19 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kay Sievers <kay.sievers@vrfy.org>
cc: =?UTF-8?B?QmFydMWCb21pZWogWmltb8WE?= <uzi18@o2.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: [regression 2.6.33 rc3-rc5] sata_nv and no /dev files
In-Reply-To: <ac3eb2511001311545j4abe0da3x58db0152caca845e@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1002012143330.4617@axis700.grange>
References: <1f9bac08.1a5266d6.4b66012a.5a11a@o2.pl>
 <ac3eb2511001311545j4abe0da3x58db0152caca845e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.56999999999999995
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Feb 2010, Kay Sievers wrote:

> On Sun, Jan 31, 2010 at 23:16, Bartłomiej Zimoń <uzi18@o2.pl> wrote:
> > cat /proc/partitions shows partitions but fstab cant mount because no /dev/sdxx files.
> > Have chacked on rc4 and rc5 and dont rememmber if rc3 is affected, but it could.
> > rc1 is abs ok.
> 
> What does:
>   grep . /sys/class/block/*/dev
> print?

This problem - udev not creating sd* nodes - appears for me with arbitrary 
SCSI / SATA drivers if CONFIG_SYSFS_DEPRECATED_V2 is set, but that's been 
the case under 2.6.32 too, not sure since which kernel version exactly. 
The OP is claiming, that rc1 was fine, is he sure his .config was the same 
in both cases?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
