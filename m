Return-Path: <linux-kernel-owner+w=401wt.eu-S1754405AbZDUUce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbZDUUce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 16:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbZDUUcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 16:32:22 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:56099 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbZDUUcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 16:32:21 -0400
Subject: Re: [RFC][PATCH] Dynamic Tick: Allow 32-bit machines to sleep for
 more than 2.15 seconds
From: john stultz <johnstul@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jon Hunter <jon-hunter@ti.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090421063523.GA8020@elte.hu>
References: <49ECE615.2010800@ti.com>  <20090421063523.GA8020@elte.hu>
Content-Type: text/plain
Date: Tue, 21 Apr 2009 13:32:16 -0700
Message-Id: <1240345936.6080.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-21 at 08:35 +0200, Ingo Molnar wrote:
> * Jon Hunter <jon-hunter@ti.com> wrote:
> > Anyway, making this change has allowed my 32-bit machine to sleep 
> > for longer than ~2.15 seconds and thought this could be of 
> > interest to others. Your comments/feedback would be appreciated.
> >
> Looks like a good thing at first sight. Thomas, John, what do you 
> think?

The concern is many clocksources wrap after a handful of seconds. The
acpi_pm is the best example (its only 24 bits wide). 

I brought this issue up earlier, and provided some example code that
could be used to limit the idle time appropriately for the current
clocksource here:

http://lkml.indiana.edu/hypermail/linux/kernel/0901.3/02693.html

Jon: Did you see that mail, or is there a reason you didn't adapt this
code into your patch? 


thanks
-john


