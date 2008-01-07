Return-Path: <linux-kernel-owner+w=401wt.eu-S1757121AbYAGLoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbYAGLoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 06:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808AbYAGLoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 06:44:15 -0500
Received: from fmmailgate05.web.de ([217.72.192.243]:41657 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743AbYAGLoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 06:44:14 -0500
Date: Mon, 07 Jan 2008 12:44:11 +0100
Message-Id: <90714065@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: cksim@singnet.com.sg
Cc: linux-kernel@vger.kernel.org
Subject: Re: Size of kernel halts startup
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1983fGoW+BMPgOX3mkLsXSZgkeo9ztapcuoxHMUlJ63CZTPI
 KgFmQTLa+5r5FWhSckQQEz8jPWApmGdDcuxVe31hT3WrlUoC1Y=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>4) Yesterday, I have done a menuconfig and turned on some drivers (USB HID and I2C).  \
>This resulted in a kernel size of about 1.4MB.

if you saved your old .config you could add those features one after the other to see if it`s size related....

>5) Booting up this 1.4MB kernel over NFS causes a register dump to appear and the \
>system is halted.
>Is this issue related to the size of the kernel or it is due to some conflict in \
>memory ?

hard to tell without any further information on this.

>If it is related to size of kernel, how can the size be increased so as to resolve \
>this issue ?

i assume you meant decrease!?

get a in-depth knowlegde about all the different config options and decide if you need it or not.

maybe after compile, some
find . -name "*.o" |while read file;do ls -s $file;done |sort -n
will help identifying parts of the kernel which take up most of the space

maybe CONFIG_EMBEDDED=y helps, too.

furthermore, there are projects like http://www.selenic.com/linux-tiny/ to  make kernel small for embedded systems.

a nice (but more generic) article about downsizing linux for embedded system is at http://www.linuxjournal.com/article/9686

i think these mailing lists provide better help since it`s more likely to meet people there who develop for ARCH=arm

http://marc.info/?l=linux-arm&r=1&w=2
http://marc.info/?l=linux-arm-kernel&r=1&w=2

regards
roland


>Appreciate any help and advises.
>
>Thanks in advance.
>
>Sim CK

>List:       linux-kernel
>Subject:    Size of kernel halts startup
>From:       cksim <cksim () singnet ! com ! sg>
>Date:       2008-01-07 3:28:29
>Message-ID: 1199676509.47819c5deaf60 () discus ! singnet ! com ! sg
>[Download message RAW]
>
>Hi,
>
>Yesterday, I have encountered an issue when the kernel size is more than 1.3MB.
>
>Info on problem encountered as follows:
>1) I am using Atmel AT91SAM9261 part. Circuit similar to that of AT91SAM9261EK
>evaluation board.
>
>2) I am booting the kernel through NFS. Bootloader
>used is UBoot 1.1.5. Kernel used is 2.6.23.1
>
>3) For the past weeks, the kernel size was about 1.3MB and kernel bootup over NFS was \
>fine.
>
>4) Yesterday, I have done a menuconfig and turned on some drivers (USB HID and I2C).  \
>This resulted in a kernel size of about 1.4MB.
>
>5) Booting up this 1.4MB kernel over NFS causes a register dump to appear and the \
>system is halted.
>
>Is this issue related to the size of the kernel or it is due to some conflict in \
>memory ?
>
>If it is related to size of kernel, how can the size be increased so as to resolve \
>this issue ?
>
>Appreciate any help and advises.
>
>Thanks in advance.
>
>Sim CK
______________________________________________________________________
XXL-Speicher, PC-Virenschutz, Spartarife & mehr: Nur im WEB.DE Club!		
Jetzt testen! http://produkte.web.de/club/?mc=021130

