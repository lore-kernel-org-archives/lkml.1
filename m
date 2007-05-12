Return-Path: <linux-kernel-owner+w=401wt.eu-S1757449AbXELG4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbXELG4s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 02:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755296AbXELG4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 02:56:41 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751076AbXELG4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 02:56:40 -0400
Date: Fri, 11 May 2007 23:56:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       linux-acpi@vger.kernel.org
Subject: Re: [patch 3/3] clockevents: Fix resume logic - updated version
Message-Id: <20070511235607.83ad0eb5.akpm@linux-foundation.org>
In-Reply-To: <200705112309.15996.rjw@sisk.pl>
References: <20070430102837.748238000@linutronix.de>
	<20070511132846.5ebf4437.akpm@linux-foundation.org>
	<200705112302.47726.rjw@sisk.pl>
	<200705112309.15996.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007 23:09:15 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> > > 
> > > hm, Fedora don't seem to want to give me an RPM which contains acpidump and
> > > all the yum servers are featuring scrogged checksums.  I could build it, I
> > > guess, but there's a principle involved ;)
> > > 
> > > http://userweb.kernel.org/~akpm/dsdt is /proc/acpi/dsdt.  Is that OK?
> > 
> > Yes, thanks.
> 
> Hmm, have you tried to do 'echo shutdown > /sys/power/disk' before the
> hibernation?

That didn't change the behaviour.
