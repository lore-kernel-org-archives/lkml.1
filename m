Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbXLMAOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbXLMAOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 19:14:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbXLMANy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 19:13:54 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:49358 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbXLMANx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 19:13:53 -0500
Date: Thu, 13 Dec 2007 01:13:52 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Rene Herman <rene.herman@gmail.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFT] Port 0x80 I/O speed
In-Reply-To: <Pine.LNX.4.64.0712130041590.32346@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0712130110510.32346@fbirervta.pbzchgretzou.qr>
References: <475F1DC6.5090403@keyaccess.nl> <Pine.LNX.4.64.0712130041590.32346@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 13 2007 00:54, Jan Engelhardt wrote:
>
>Transmeta TM5800 CPU with nominal frequency 933 MHz, but it has a
>hardware(!) 'ondemand' governor over the range of frequencies that
>the user allowed scaling over, irrespective of the software governor.
>(That is, if the CPU can do 300,533 and 933 MHz, and setting the
>min/max to 300/533 will cause the hardware to 'ondemand' between 300
>and 533 only. And that even if 'performance' is set on the software
>side - so the only way to enforce 'performance' is to actually set
>min=933.)
>
>00:46 takeshi:../cpu0/cpufreq # echo 300000 >scaling_min_freq
>00:46 takeshi:../cpu0/cpufreq # echo 933000 >scaling_max_freq
>00:42 takeshi:/dev/shm # for ((x=1;x<=10;++x)); do ./port80 ; done
>cycles: out 1514, in 584
^ most likely 300 MHz state
>cycles: out 1371, in 516
^ 533 MHz state
>cycles: out 1291, in 472
^ ??
>cycles: out 1304, in 437
^ ??
>cycles: out 1308, in 410
^ ??
>cycles: out 1315, in 419
^ 933 MHz state
>cycles: out 1315, in 419
>cycles: out 1314, in 419
>cycles: out 1315, in 420
>cycles: out 1315, in 419

...this is in stark contrast to values of other users, where,
skimming through the mails, higher cpu frequencies yields
higher out/in values, but not so on TM5800. Highly interesting.
