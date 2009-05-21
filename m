Return-Path: <linux-kernel-owner+w=401wt.eu-S1752223AbZEUFLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbZEUFLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 01:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbZEUFLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 01:11:44 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:22943 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbZEUFLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 01:11:43 -0400
MIME-Version: 1.0
In-Reply-To: <20090520081443.GA8684@one.firstfloor.org>
References: <a24804730905160036j2720c557o347cec1513df9c4a@mail.gmail.com>
	 <87eiumq3w2.fsf@basil.nowhere.org>
	 <a24804730905200011l202733abh89f5d4feaf69610e@mail.gmail.com>
	 <20090520081443.GA8684@one.firstfloor.org>
Date: Wed, 20 May 2009 22:11:44 -0700
Message-ID: <a24804730905202211w77f2d0bay96d22b05e9c45d81@mail.gmail.com>
Subject: Re: [RFC] mod_timer() helper functions?
From: Chris Peterson <cpeterso@cpeterso.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> int timer_settime_msecs(struct timer_list *timer, int msecs)
>
> At least this function needs something that indicates it is very approximate
> (upto 900% error for 1ms with HZ=100)
> The old open coded pattern showed this.

I see your point. But doesn't the open coded pattern with jiffies
imply an even greater timer precision than milliseconds? Or does
mod_timer()'s use of an expiration time instead of a time delay avoid
promising more precision than it can provide?

Quite of a few mod_timer() calls already try to schedule precise
timeouts in terms of HZ/10 or HZ/20.


chris
