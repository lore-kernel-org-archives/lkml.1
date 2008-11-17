Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbYKQUDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbYKQUDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 15:03:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbYKQUCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 15:02:55 -0500
Received: from mail.gmx.net ([213.165.64.20]:54088 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751902AbYKQUCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 15:02:54 -0500
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX19ksupRUZZkukPpDzOLQppBQHAEsQmwiVt/gW+urS
	l1uaQ4yC3EiP0Q
From: Marvin <marvin24@gmx.de>
To: Fabiano Manoel de Andrade <fabianoma@gmail.com>
Subject: Re: RTC problem in PS3
Date: Mon, 17 Nov 2008 21:02:11 +0100
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, cbe-oss-dev@ozlabs.org,
       linuxppc-dev@ozlabs.org
References: <1226875490.6597.11.camel@lottar>
In-Reply-To: <1226875490.6597.11.camel@lottar>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811172102.12286.marvin24@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

forward to a better place...

On Sunday 16 November 2008 23:44:50 Fabiano Manoel de Andrade wrote:
> 	Hi I've compiled the latest version of linux kernel (2.6.27.6) in my
> PS3 running debian and get a warning message listed here
>
> 	Setting the system clock.
>   	Cannot access the Hardware Clock via any known method.
>   	Use the --debug option to see the details of our search for an access
> method. * Unable to set System Clock to: Sun Nov 16 20:33:06 UTC 2008
>
>
> 	The problem can be reproduced with the commands
>
> 	# hwclock --debug
>  	hwclock from util-linux-ng 2.13.1.1
>   	hwclock: Open of /dev/rtc failed, errno=2: No such file or directory.
>   	No usable clock interface found.
>   	Cannot access the Hardware Clock via any known method.
>   	# ls -l /dev/rtc*
>   	ls: cannot access /dev/rtc*: No such file or directory
>
> 	Loading the rtc-ppc module solve the problem, but after restart
> the system I still have the problem. Looking at kernel config I change the
> rtc-ppc to be build into kernel and this solve totally the problem. So the
> ps3_defconfig must set the rtc-ppc to be build into kernel.
>
> 	Thanks in advance.
> 	Fabiano.

