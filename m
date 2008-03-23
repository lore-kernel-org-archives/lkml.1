Return-Path: <linux-kernel-owner+w=401wt.eu-S1757219AbYCWC6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbYCWC6Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 22:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYCWC6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 22:58:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42944 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbYCWC6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 22:58:14 -0400
Message-ID: <47E5C2C8.9030201@kernel.org>
Date: Sat, 22 Mar 2008 19:39:04 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Thomas Meyer <thomas@m3y3r.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported
 regressions from 2.6.24)
References: <200803220259.48534.rjw@sisk.pl> <47E5350D.101@s5r6.in-berlin.de>	 <47E540E7.7030108@m3y3r.de> <47E54FA6.3060809@s5r6.in-berlin.de>	 <47E557D5.9020604@s5r6.in-berlin.de>	 <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org>	 <47E5815B.4080002@kernel.org>	 <86802c440803221628p60ebab7co3c4a6c1bef39d709@mail.gmail.com>	 <47E596DE.2090801@kernel.org> <86802c440803221900w1516e565yc6e5e26293acf5fe@mail.gmail.com>
In-Reply-To: <86802c440803221900w1516e565yc6e5e26293acf5fe@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Sat, Mar 22, 2008 at 4:31 PM, H. Peter Anvin <hpa@kernel.org> wrote:
>> Yinghai Lu wrote:
>>  > Opteron system with coprocessor on socket or HTX slot. will use 64bit
>>  > BAR above 4g and size is more than 4g too.
>>
>>  And it's working, with a 32-bit kernel?
> 
> don't think so.

Would you mind trying it out, with Linus' patch?

	-hpa
