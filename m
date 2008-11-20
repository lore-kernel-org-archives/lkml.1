Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbYKTXU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbYKTXU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 18:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbYKTXUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 18:20:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37716 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbYKTXUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 18:20:50 -0500
Message-ID: <4925F095.40107@zytor.com>
Date: Thu, 20 Nov 2008 15:19:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dimitri Sivanich <sivanich@sgi.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 2/2 v3] SGI RTC: add generic timer system interrupt
References: <20081023163041.GA14574@sgi.com>	<20081119212202.GA3377@sgi.com>	<20081119212350.GB3377@sgi.com>	<20081119212631.GC3377@sgi.com> <20081120151208.f7892050.akpm@linux-foundation.org>
In-Reply-To: <20081120151208.f7892050.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>
>> Refreshing this to use 0xed as the vector.  Have repackaged it to be more
>> generic.
>>

What happened to the concept of using normal IRQs for this, via a custom
irqchip?  Adding more reserved vectors really sucks, and it affects
non-SGI platforms, which could potentially run out of vectors as a result.

	-hpa
