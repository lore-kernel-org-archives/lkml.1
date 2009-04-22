Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbZDVPaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbZDVPaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 11:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbZDVPah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 11:30:37 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:56947 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbZDVPag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 11:30:36 -0400
Message-ID: <49EF37FC.8020909@nortel.com>
Date: Wed, 22 Apr 2009 09:30:04 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Jon Hunter <jon-hunter@ti.com>
CC: john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Dynamic Tick: Allow 32-bit machines to sleep for
 more than 2.15 seconds
References: <49ECE615.2010800@ti.com>  <20090421063523.GA8020@elte.hu>	 <1240345936.6080.6.camel@localhost>  <49EE54B4.9020700@ti.com> <1240358715.6080.42.camel@localhost> <49EE89EF.1000707@ti.com>
In-Reply-To: <49EE89EF.1000707@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Apr 2009 15:30:06.0417 (UTC) FILETIME=[36B8F410:01C9C35F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Hunter wrote:

> So this 
> assumes that long long will be a 64-bit type which I don't like. 
> However, this would not cause any compilation issues even if long long 
> turned out to be 32-bits or 128-bits (if this is even possible).

Isn't "long long" guaranteed to be 64-bit on all linux systems?

Unless the width is critical, I'd prefer to stay away from u64 until it 
gets unified between architectures.  I recently ran into a problem 
printk-ing a "u64" value because it was a different type on ppc64 than 
x86-64.


Chris
