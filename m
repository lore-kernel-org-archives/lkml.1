Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbYLJJKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbYLJJKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 04:10:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbYLJJKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 04:10:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47221 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbYLJJKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 04:10:32 -0500
Message-ID: <493F8671.6020709@zytor.com>
Date: Wed, 10 Dec 2008 01:05:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Yinghai Lu <yinghai@kernel.org>, Huang Ying <ying.huang@intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "norman@thebacks.co.uk" <norman@thebacks.co.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Alok Kataria <alokkataria1@gmail.com>,
       =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <"bruno .premont"@restena.lu>,
       "xl@xlsigned.net" <xl@xlsigned.net>, "dsd@gentoo.org" <dsd@gentoo.org>
Subject: Re: [PATCH] Fix VMI crash on boot in 2.6.27+ kernels
References: <1228870222.8766.15.camel@bodhitayantram.eng.vmware.com>	 <86802c440812091715r775d514eh3acf9add9e24184e@mail.gmail.com>	 <493F2009.6060300@zytor.com> <1228894281.8766.22.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1228894281.8766.22.camel@bodhitayantram.eng.vmware.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
>>>
>> I have mentioned in the past that I think the very concept of relocating
>> the fixmap to be utterly braindead.  Instead, I believe we should locate
>> it low in kernel space so it doesn't have to be relocated.  It's
>> unfortunately a relatively large change.
> 
> I agree, but a bit too late for 2.6.27 stable and 2.6.28-rc.
> 

Of course, no argument there.

	-hpa
