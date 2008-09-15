Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbYIORZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbYIORZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 13:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbYIORZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 13:25:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48597 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbYIORZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 13:25:41 -0400
Message-ID: <48CE9A5C.1030603@zytor.com>
Date: Mon, 15 Sep 2008 10:24:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] introduce boot_printk()
References: <1221465916-30889-1-git-send-email-yhlu.kernel@gmail.com>	 <48CE983C.8040709@zytor.com> <86802c440809151018k2c7874dfjc8e9791bee9365f9@mail.gmail.com>
In-Reply-To: <86802c440809151018k2c7874dfjc8e9791bee9365f9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> some guys complained that it is even too verbose with KERN_DEBUG
> 

I can understand the desire to enable filtering on a 
subsystem-by-subsystem basis, but I think rather than doing a 
subsystem-specific hack we should do something that any subsystem can use.

Perhaps we could extend the current <level> hack to include a subsystem, 
something like:

<7><x86>Your blort driver seems to be befudged, trying blarfing.

... and something like "loglevel=x86:7,acpi:3,..."

	-hpa

