Return-Path: <linux-kernel-owner+w=401wt.eu-S1764181AbYBVHr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764181AbYBVHr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 02:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbYBVHru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 02:47:50 -0500
Received: from smtp.ono.com ([62.42.230.12]:22115 "EHLO resmaa02.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753454AbYBVHrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 02:47:49 -0500
Date: Fri, 22 Feb 2008 08:47:40 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: [rtc-linux] state of GEN_RTC vs rtc subsystem
Message-ID: <20080222084740.00102290@werewolf>
In-Reply-To: <20080220180325.46446675@i1501.lan.towertech.it>
References: <47B18612-66A3-476C-B81C-F2FD11CE9A64@kernel.crashing.org>
	<20080220180325.46446675@i1501.lan.towertech.it>
X-Mailer: Claws Mail 3.3.0cvs20 (GTK+ 2.12.8; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 18:03:25 +0100, Alessandro Zummo <alessandro.zummo@towertech.it> wrote:

> On Wed, 20 Feb 2008 10:11:23 -0600
> Kumar Gala <galak@kernel.crashing.org> wrote:
> 
> > 
> > Is the functionality provided by drivers/char/gen_rtc.c completely  
> > handled by the rtc subsystem in drivers/rtc?
> > 
> > I ask for two reasons:
> > 1. should we make it mutually exclusive in Kconfig
> > 2. I've enabled both and get (we'll my defconfig did):
> 
>  They shouldn't be enabled at once. I think a patch 
>  for Kconfig has been recently submitted to give a warning
>  in such a case.
> 
>  rtc-cmos should be able to handle the vast majority of x86
>  rtcs out there. 
> 

In fact, you have 3 rtc implementations available.
Please, can you take a look at this question also:

http://marc.info/?l=linux-kernel&m=120355254713965&w=2

>  The only real open issue is related to the ntp synchronization
>  mode and will be solved only when we can get rid of it :)
> 


-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux 2.6.23-jam05 (gcc 4.2.2 20071128 (4.2.2-2mdv2008.1)) SMP PREEMPT
