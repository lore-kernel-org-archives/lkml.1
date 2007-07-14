Return-Path: <linux-kernel-owner+w=401wt.eu-S1761041AbXGNSX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761041AbXGNSX4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 14:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759135AbXGNSXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 14:23:48 -0400
Received: from www.osadl.org ([213.239.205.134]:44589 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759123AbXGNSXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 14:23:47 -0400
Subject: Re: 2.6.22-rc6-mm1
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       john stultz <johnstul@us.ibm.com>
In-Reply-To: <20070714020713.36f604d2.akpm@linux-foundation.org>
References: <fa.GKNLH/oj9PSCnQCxx9ZAggjc5uA@ifi.uio.no>
	 <469879A2.1000002@shaw.ca>
	 <20070714020713.36f604d2.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 14 Jul 2007 20:23:46 +0200
Message-Id: <1184437426.12353.341.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-14 at 02:07 -0700, Andrew Morton wrote:
> +	if (0 && (id & HPET_ID_LEGSUP)) {
>  		hpet_enable_int();
>  		hpet_reserve_platform_timers(id);
>  		/*
> _
> 
> will, if executed (on x86_64, at least), instaoops the machine.  It might
> take down i386 as well, dunno.
> 
> I'd forgotten about this problem, and it seems that Thomas & John have too.
> It's a showstopper.

No, I have not. I found and solved the problem. Updates to the x8664
hrtimer queue are going out tomorrow.

	tglx



