Return-Path: <linux-kernel-owner+w=401wt.eu-S1757296AbYC1RsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbYC1RsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 13:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757126AbYC1RsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 13:48:10 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:37986 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757120AbYC1RsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 13:48:07 -0400
Date: Fri, 28 Mar 2008 19:47:50 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: David Brownell <david-b@pacbell.net>, Mark Lord <lkml@rtr.ca>,
       David Miller <davem@davemloft.net>, jkosina@suse.cz, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, pavel@suse.cz,
       akpm@linux-foundation.org, rtc-linux@googlegroups.com
Subject: Re: 2.6.25-rc7: Ugh.
Message-ID: <20080328174750.GH32200@cs181133002.pp.htv.fi>
References: <20080327160700.GB828@suse.de> <200803272358.20081.david-b@pacbell.net> <20080328091645.GI21413@elte.hu> <200803280249.42193.david-b@pacbell.net> <alpine.LNX.1.10.0803281555570.27567@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0803281555570.27567@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 03:56:49PM +0100, Jan Engelhardt wrote:
>
> On Friday 2008-03-28 10:49, David Brownell wrote:
>> @@ -303,6 +299,7 @@ comment "Platform RTC drivers"
>> config RTC_DRV_CMOS
>> 	tristate "PC-style 'CMOS'"
>> 	depends on X86 || ALPHA || ARM || M32R || ATARI || PPC || MIPS
>> +	default y if X86
>> 	help
>> 	  Say "yes" here to get direct support for the real time clock
>> 	  found in every PC or ACPI-based system, and some other boards.
>
> I do not see why it should default to y, given that udev loads my m
> perfectly fine.

Then there's no problem with having it default to "y".

The usual case is to have a driver disabled by default, and when it's 
that common that we do not want it disabled by default we can as well 
immediately let it default to "y".

The user still has all three choices.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

