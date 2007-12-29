Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbXL2PvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbXL2PvT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 10:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbXL2PvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 10:51:07 -0500
Received: from fmmailgate04.web.de ([217.72.192.242]:46115 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbXL2PvG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 10:51:06 -0500
Date: Sat, 29 Dec 2007 16:51:04 +0100
Message-Id: <75317208@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: dl9pf@gmx.de, jcm@jonmasters.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kbuild: modules_install regression ? - depmod
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX19VG13teaEYP6gksgCLKJHkCyNa7V80tdYVyVzMBGujXfplq
 x4UHOCDeCpNMO6LqCc1qEreQfO/leWBPFwlvhMQE6afynAKLdA=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Erm... same system here -
> 
> $ gzip -cd /proc/config.gz | grep DEBUG_INFO
> # CONFIG_DEBUG_INFO is not set
> 
> I think you managed to snafu something during building.

mhh - i have kernel-default-2.6.22.13-0.3 kernel (didn`t touch that since online update) and this has CONFIG_DEBUG_INFO=y
wondering about that, i installed shipping kernel (kernel-default-2.6.22.5-31 from http://download.opensuse.org/distribution/openSUSE-current/repo/oss/suse/i586/ ) 

but:

opensuse103:~ # uname -a
Linux opensuse103 2.6.22.5-31-default #1 SMP 2007/09/21 22:29:00 UTC i686 i686 i386 GNU/Linux

opensuse103:~ # zcat /proc/config.gz |grep DEBUG_INFO
CONFIG_DEBUG_INFO=y

so i don`t plead guilty.......



> -----Ursprüngliche Nachricht-----
> Von: "Jan Engelhardt" <jengelh@computergmbh.de>
> Gesendet: 29.12.07 15:08:10
> An: devzero@web.de
> CC: jcm@jonmasters.org, dl9pf@gmx.de,     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> Betreff: Re: kbuild: modules_install regression ? - depmod


> 
> 
> On Dec 29 2007 14:30, devzero@web.de wrote:
> >> On Dec 28 2007 16:08, devzero@web.de wrote:
> >> >
> >> >i have the same issue, but with 2.6.24-rc6 on a box with 512MB RAM
> >> >
> >> >System is openSUSE 10.3
> >>
> >> If you enable CONFIG_DEBUG_INFO, don't be surprised.
> >
> >oh yes, that`s it!
> >
> >apparently CONFIG_DEBUG_KERNEL, CONFIG_DEBUG_BUGVERBOSE and CONFIG_DEBUG_INFO
> >defaults to "y" on my distro`s kernel, and i just copied config from
> >/proc/config.gz and did a "make oldconfig".
> 
> Erm... same system here -
> 
> $ gzip -cd /proc/config.gz | grep DEBUG_INFO
> # CONFIG_DEBUG_INFO is not set
> 
> I think you managed to snafu something during building.
> 


______________________________________________________________________________
Jetzt neu! Im riesigen WEB.DE Club SmartDrive Dateien freigeben und mit 
Freunden teilen! http://www.freemail.web.de/club/smartdrive_ttc.htm/?mc=021134

