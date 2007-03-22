Return-Path: <linux-kernel-owner+w=401wt.eu-S934208AbXCVT4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934208AbXCVT4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 15:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934213AbXCVT4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 15:56:49 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44166 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934208AbXCVT4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 15:56:48 -0400
Subject: Re: [BUG] no boot with 2.6.21-rc3 and later
From: john stultz <johnstul@us.ibm.com>
To: Bob Tracy <rct@gherkin.frus.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, bunk@stusta.de, jikos@jikos.cz,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070322193946.2B7D8DBA1@gherkin.frus.com>
References: <20070322193946.2B7D8DBA1@gherkin.frus.com>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 12:56:42 -0700
Message-Id: <1174593402.5662.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-22 at 13:39 -0600, Bob Tracy wrote:
> john stultz wrote:
> > On Thu, 2007-03-22 at 13:14 -0600, Bob Tracy wrote:
> > > john stultz wrote:
> > > > Try this patch and let me know if it does the right thing.
> > > 
> > > Will do.  I'll report back in a few hours.
> > > 
> > > > Although I do
> > > > still need to dig a bit on the PIT hang issue.
> > > 
> > > Any chance this might be related to the APIC issues currently being
> > > discussed in other threads?
> > 
> > Hmmm. Good thought, I'll have to look into it. It could be that if the
> > PIT is disabled in favor of the local apic, we'll have to make sure its
> > not being used as a clocksource.
> 
> According to the dmesg output, the local apic is disabled in the BIOS on
> this system, and I'm not booting with "lapic" to enable it.
> 
> Anyway, the "few hours" turned out to be more like a few minutes :-).
> The patch worked as far as selecting/installing the acpi_pm clocksource
> instead of the pit clocksource, and there was no hang during boot.  If
> you would like to see the dmesg output, let me know and I'll forward it
> to you in a separate message.

Great to hear! Please do send me the dmesg output so I can look to
narrow down what's happening w/ the PIT.

I'll also go ahead and push that acpi_pm change to akpm.

thanks
-john


