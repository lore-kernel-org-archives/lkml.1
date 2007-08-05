Return-Path: <linux-kernel-owner+w=401wt.eu-S932503AbXHEAHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503AbXHEAHA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 20:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756264AbXHEAGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 20:06:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36405 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756226AbXHEAGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 20:06:50 -0400
Message-ID: <46B5148E.50302@zytor.com>
Date: Sat, 04 Aug 2007 17:06:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       rtc-linux@googlegroups.com
Subject: Re: rtc max frequency setting
References: <Pine.LNX.4.64.0708050042560.14443@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708050042560.14443@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> Hi,
> 
> with the old rtc.ko module, there was a /proc/sys/dev/rtc/max-user-freq 
> that could be set. With rtc_cmos.ko (or the new rtc infrastructure in 
> general), I am missing this file. Where can I set the max-user-freq now, 
> or is this obsolete now? (mplayer prefers to have user-freq to be >= 1024.)
> 

Qemu wants something like this too.  Both of these really want something
else, which is a high-frequency userspace timer.

What is the best way to do that on modern kernels?

	-hpa
