Return-Path: <linux-kernel-owner+w=401wt.eu-S1755008AbYKDUT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbYKDUT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 15:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbYKDUTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 15:19:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45191 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbYKDUTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 15:19:52 -0500
Message-ID: <4910AD4B.5070807@zytor.com>
Date: Tue, 04 Nov 2008 12:15:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, Alexander van Heukelum <heukelum@fastmail.fm>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, lguest@ozlabs.org,
       jeremy@xensource.com, Steven Rostedt <srostedt@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Mike Travis <travis@sgi.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
References: <20081104122839.GA22864@mailshack.com> <20081104124242.GA6795@elte.hu> <1225805399.25337.1282903253@webmail.messagingengine.com> <20081104140030.GA16178@elte.hu> <4910AA51.3070602@goop.org>
In-Reply-To: <4910AA51.3070602@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Ingo Molnar wrote:
>> ( another advantage is that the 6 bytes GDT descriptor is more  
>> compressed and hence uses up less L1/L2 cache footprint than the  
>> larger (~7 byte) trampolines we have at the moment. )
>>   
> 
> Also its D cache rather than I cache, which is generally more
> plentiful.  However, I think the cost of GDT cache misses on exception
> latency is something that we've largely overlooked, and this will make
> it a bigger factor (vs cache misses on the actual exception handler code
> itself, which should be reduced).
> 

Besides, a GDT entry is 8 bytes, not 6.

	-hpa
