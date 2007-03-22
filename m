Return-Path: <linux-kernel-owner+w=401wt.eu-S933166AbXCVTjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933166AbXCVTjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 15:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934199AbXCVTjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 15:39:48 -0400
Received: from gherkin.frus.com ([192.158.254.49]:40711 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933166AbXCVTjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 15:39:48 -0400
Subject: Re: [BUG] no boot with 2.6.21-rc3 and later
In-Reply-To: <1174591552.5662.8.camel@localhost.localdomain> "from john stultz
 at Mar 22, 2007 12:25:52 pm"
To: john stultz <johnstul@us.ibm.com>
Date: Thu, 22 Mar 2007 13:39:46 -0600 (CST)
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, bunk@stusta.de, jikos@jikos.cz,
       Thomas Gleixner <tglx@linutronix.de>
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070322193946.2B7D8DBA1@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:
> On Thu, 2007-03-22 at 13:14 -0600, Bob Tracy wrote:
> > john stultz wrote:
> > > Try this patch and let me know if it does the right thing.
> > 
> > Will do.  I'll report back in a few hours.
> > 
> > > Although I do
> > > still need to dig a bit on the PIT hang issue.
> > 
> > Any chance this might be related to the APIC issues currently being
> > discussed in other threads?
> 
> Hmmm. Good thought, I'll have to look into it. It could be that if the
> PIT is disabled in favor of the local apic, we'll have to make sure its
> not being used as a clocksource.

According to the dmesg output, the local apic is disabled in the BIOS on
this system, and I'm not booting with "lapic" to enable it.

Anyway, the "few hours" turned out to be more like a few minutes :-).
The patch worked as far as selecting/installing the acpi_pm clocksource
instead of the pit clocksource, and there was no hang during boot.  If
you would like to see the dmesg output, let me know and I'll forward it
to you in a separate message.

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
