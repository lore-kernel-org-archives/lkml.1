Return-Path: <linux-kernel-owner+w=401wt.eu-S934071AbYBUARt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934071AbYBUARt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 19:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754372AbYBUARj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 19:17:39 -0500
Received: from mx0.towertech.it ([213.215.222.73]:34269 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754292AbYBUARi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 19:17:38 -0500
Date: Thu, 21 Feb 2008 01:14:25 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: woodys@xandros.com, galak@kernel.crashing.org,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>, rz@linux-m68k.org
Subject: Re: [rtc-linux] Re: state of GEN_RTC vs rtc subsystem
Message-ID: <20080221011425.2f8ad363@i1501.lan.towertech.it>
In-Reply-To: <47BC8F88.80502@xandros.com>
References: <47B18612-66A3-476C-B81C-F2FD11CE9A64@kernel.crashing.org>
	<47BC8F88.80502@xandros.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 15:37:28 -0500
woodys <woodys@xandros.com> wrote:

> On ARM genrtc has been arbitrary disabled in Kconfig circa 2.6.19 and 
> the change to rtc_cmos it is not 100% transparent (ARM Netwinder, Debian).
> If I want to use a current (Etch) hwclock binary - I need genrtc with 
> /dev/rtc at 10,135, however new rtc_cmos creates /dev/rtc0 at 254,0.
> As a result on new kernels hwclock claims that it is not able to access 
> hardware.
> 
> However upgrading the util-linux package will (sometime in the 
> "unstable" future) solve it, so it is not completely broken... Still, at 
> the moment - genrtc seems to be a better solution...

 Strange that it has been disabled, I used to keep an eye to avoid touching
 anything outside of drivers/rtc .

 the rtc subsystem creates the device dynamically, you shouldn't count
 on having 254,0. I would eventually ack a patch that adds
 /dev/rtc at 10,135 as an alias for /dev/rtc0.

 however the best solution would be to upgrade hwclock.


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

