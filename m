Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbXFOHD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbXFOHD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 03:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbXFOHDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 03:03:20 -0400
Received: from eazy.amigager.de ([213.239.192.238]:47352 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbXFOHDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 03:03:20 -0400
Date: Fri, 15 Jun 2007 09:03:19 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Subject: Re: rtc_cmos: error after first write to wakealarm
Message-ID: <20070615070319.GA19455@dose.home.local>
Mail-Followup-To: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
	linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
References: <20070615063308.GA18089@dose.home.local> <20070615155904.1d1da892.yoichi_yuasa@tripeaks.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070615155904.1d1da892.yoichi_yuasa@tripeaks.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 15:59:04 +0900, Yoichi Yuasa wrote:
> On Fri, 15 Jun 2007 08:33:08 +0200
> Tino Keitel <tino.keitel@gmx.de> wrote:
> 
> > Hi,
> > 
> > I have the following strange behaviour with rtc_cmos:
> > 
> > $ echo 1181934240 > /sys/class/rtc/rtc0/wakealarm
> > bash: echo: write error: Device or resource busy
> > $ rmmod rtc_cmos
> > $ modprobe rtc_cmos
> > $ echo 1181934240 > /sys/class/rtc/rtc0/wakealarm
> > $ echo 1181934240 > /sys/class/rtc/rtc0/wakealarm
> > bash: echo: write error: Device or resource busy
> > $
> 
> If the alarm has already been enabled, you cannot set the next alarm. 
> You should disable first.

Ah, ok.
  
Where is the documentation that describes that I have to disable it
first, and how to do this? A migration document for /proc/acpi/alarm   
users would be nice, too.

Regards,
Tino
