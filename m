Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbYGOKrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbYGOKrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 06:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754909AbYGOKrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 06:47:45 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:60861 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754915AbYGOKro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 06:47:44 -0400
Date: Tue, 15 Jul 2008 11:47:41 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Hebbar <gururajakr@sanyo.co.in>
Cc: linux-kernel@vger.kernel.org
Subject: Re: need help to enable ARM AMBA PL031 RTC
Message-ID: <20080715104741.GF24620@fluff.org.uk>
References: <18462244.post@talk.nabble.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18462244.post@talk.nabble.com>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 03:43:14AM -0700, Hebbar wrote:
> 
> I all,
> 
> I am working on customized arm versatile board and i am trying to use ARM
> AMBA PL031 RTC.

linux-arm-kernel@lists.arm.linux.org.uk is the right place to
discuss this, although I belive it is moderated for non-subscribers.
 
>  i enabled CONFIG_RTC_DRV_PL031=y
> 
> But the date never changes or updates. 
> 
> / # cat /sys/class/rtc/rtc0/time
> 00:00:00
> 
> When i went through the Ref Manual of ARM AMBA PL031 RTC i found that we
> need to enable or set high to RTC START bit (bit 0) in RTC Control Register
> ( 0x0C ).
> 
> but in  rtc-pl031.c, RTC_START is no where set in RTC CONTROL Register.
> 
> I think we need to enable it in rtc_probe func after rtc_device_register
> returns success.
> 
> #define RTC_CR_MIE	(1 << 0)
> 
> __raw_writel(RTC_CR_MIE, ldata->base + RTC_CR);
> 
> Kindly Comment.
> 
> Regards
> Gururaja
> 
> 
> -- 
> View this message in context: http://www.nabble.com/need-help-to-enable-ARM-AMBA-PL031-RTC-tp18462244p18462244.html
> Sent from the linux-kernel mailing list archive at Nabble.com.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
