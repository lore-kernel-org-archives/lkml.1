Return-Path: <linux-kernel-owner+w=401wt.eu-S1754402AbYKTLTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbYKTLTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:19:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754852AbYKTLSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:18:53 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:29128 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755084AbYKTLSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:18:52 -0500
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Nov 2008 06:18:52 EST
X-IronPort-AV: E=Sophos;i="4.33,639,1220220000"; 
   d="scan'208";a="20168005"
Message-ID: <4925453B.5010400@loria.fr>
Date: Thu, 20 Nov 2008 12:08:43 +0100
From: Jens Gustedt <jens.gustedt@loria.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.17) Gecko/20080925 Lightning/0.9 Thunderbird/2.0.0.17 Mnenhy/0.7.5.666
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Reg Clemens <reg@dwf.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Problem with 2.6.27.5 kernel (wont load)
References: <200811200937.mAK9b3Hq005271@deneb.dwf.com>
In-Reply-To: <200811200937.mAK9b3Hq005271@deneb.dwf.com>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAACFQTFRF
 AAAAHBYVRBwdOS4reSQltSksozs7gEhFYVFKzlxarIiBkD01owAAAAF0Uk5TAEDm2GYAAAABYktH
 RACIBR1IAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH2AcHFSUs3YgN1AAAAhNJREFUOMu1
 k89r2zAUxzWyQ5ZTXwWb6c2qiU1PU3XxctqC67LcZcitMEthObVeidud6hhWs7s9cnPoIGn+yknp
 mO3Y1wlswfvo+57eDyH0P9Yb9Q12LfNAcFk+Cz5vAc4LGQoetEEupbwQ08p0K/iVisA5DyQP+NVr
 P/y4BxfKVKKF+heK5Wr3KhBavlYUYprzKfcmf6MqEIqg8JxH63OuPc5rQIYecRM21O7CvQLtQUks
 3zPhmJzlXMqXGCKYXaMefevZ0dlCjne+CK/3oNBbj/34ZEXEn8S73SKucukDux/bSzIj904j71cM
 f1iFN8uYiG8PdfBE4TyOEogtab6vgxQwUCeF2J+BUQfLFBMSR5hYJoPK1+9cTmz5dTU+MQ2MoTqv
 CjhXtSjGhglqVYpnVQZd1K2r7XBUdVtXhQex4+KmAq1US4PAcV2qCK5dqk/0SmANB4q+Okcxg7V2
 dYIagJye/nzCzdgKYHj3C1KXpqyZeB+O/eIyymiWwKhRXUpk4N9lJKNGo4aopyTjlLlZcoQOADw6
 TsoyWh5MKMC5urFLR61pB50H63gdqaGulHWAQbmjRveL2mK3054xxh66XFGgoy5fzGDM2Gxbmj5j
 NMObO+cQJJhhZnx3UnooWHzBNxSWaaOzCK2t0LTViKpxg0aYZDgz7fil5fW6r/FwY97GxATd3LoA
 hpcLUUQO/TclfwCdcJu31IbsiAAAAABJRU5ErkJggg==
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Reg Clemens schrieb:
> I have built the 2.6.27.5 kernel with and without the PPS changes,
> and in both cases the kernel build with no obvious errors, but when
> you try to load it, you get about a half dozen lines of output, and then
> 
> 	<clip>
> 	Unable to access resume device (/dev/sda5)
> 	mount: could not find filesystem '/dev/root'
> 	<clip>

looks that you compiled your filesystems as modules (why?) and didn't 
update your initramfs for your
new kernel

Jens

