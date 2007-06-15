Return-Path: <linux-kernel-owner+w=401wt.eu-S1752983AbXFOHfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbXFOHfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 03:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbXFOHfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 03:35:05 -0400
Received: from mfo32.po.2iij.NET ([210.128.50.15]:12705 "EHLO
	mfo32.po.2iij.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbXFOHfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 03:35:04 -0400
X-Greylist: delayed 2151 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jun 2007 03:35:03 EDT
Date: Fri, 15 Jun 2007 15:59:04 +0900
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
To: Tino Keitel <tino.keitel@gmx.de>
Cc: yoichi_yuasa@tripeaks.co.jp, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com
Subject: Re: rtc_cmos: error after first write to wakealarm
Message-Id: <20070615155904.1d1da892.yoichi_yuasa@tripeaks.co.jp>
In-Reply-To: <20070615063308.GA18089@dose.home.local>
References: <20070615063308.GA18089@dose.home.local>
Organization: TriPeaks Corporation
X-Mailer: Sylpheed version 1.0.4 (GTK+ 1.2.10; i386-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007 08:33:08 +0200
Tino Keitel <tino.keitel@gmx.de> wrote:

> Hi,
> 
> I have the following strange behaviour with rtc_cmos:
> 
> $ echo 1181934240 > /sys/class/rtc/rtc0/wakealarm
> bash: echo: write error: Device or resource busy
> $ rmmod rtc_cmos
> $ modprobe rtc_cmos
> $ echo 1181934240 > /sys/class/rtc/rtc0/wakealarm
> $ echo 1181934240 > /sys/class/rtc/rtc0/wakealarm
> bash: echo: write error: Device or resource busy
> $

If the alarm has already been enabled, you cannot set the next alarm. 
You should disable first.

Yoichi

