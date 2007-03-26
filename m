Return-Path: <linux-kernel-owner+w=401wt.eu-S1752445AbXCZMaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbXCZMaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 08:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbXCZMaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 08:30:07 -0400
Received: from www.osadl.org ([213.239.205.134]:36245 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752440AbXCZMaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 08:30:05 -0400
Subject: Re: Linux 2.6.21-rc5
From: Thomas Gleixner <tglx@linutronix.de>
To: Bob Tracy <rct@gherkin.frus.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       johnstul@us.ibm.com
In-Reply-To: <20070326122526.BD45DDBA1@gherkin.frus.com>
References: <20070326122526.BD45DDBA1@gherkin.frus.com>
Content-Type: text/plain
Date: Mon, 26 Mar 2007 14:30:02 +0200
Message-Id: <1174912202.4182.34.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-26 at 07:25 -0500, Bob Tracy wrote:
> Thomas Gleixner wrote:
> > This fix from John Stultz is still missing:
> > 
> > http://lkml.org/lkml/2007/3/22/287
> > 
> > It's in Andrews queue already and waits to be sent to you.
> 
> In summary, that fix is a workaround to allow the acpi_pm clocksource
> to be selected instead of the pit clocksource, thereby allowing my
> Dell laptop with the PIIX4 bug to boot.  Other apic, clocksource, etc.
> patches that were included in -rc5 fixed the problem that caused the
> boot process to hang when the pit clocksource was selected, as I
> suspected would be the case :-).

Ah. Ok

> Per John's message in the above URL, while the fix is no longer needed
> for allowing the laptop to boot, it's probably still "a good thing" to
> allow a better clocksource to be selected.

Yes. The read three times pmtimer is faster and more reliable than the
PIT.

	tglx



