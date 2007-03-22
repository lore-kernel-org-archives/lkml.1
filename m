Return-Path: <linux-kernel-owner+w=401wt.eu-S933984AbXCVT0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933984AbXCVT0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 15:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933985AbXCVT0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 15:26:04 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51386 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933984AbXCVT0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 15:26:02 -0400
Subject: Re: [BUG] no boot with 2.6.21-rc3 and later
From: john stultz <johnstul@us.ibm.com>
To: Bob Tracy <rct@gherkin.frus.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, bunk@stusta.de, jikos@jikos.cz,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070322191410.ECCBFDBA1@gherkin.frus.com>
References: <20070322191410.ECCBFDBA1@gherkin.frus.com>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 12:25:52 -0700
Message-Id: <1174591552.5662.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-22 at 13:14 -0600, Bob Tracy wrote:
> john stultz wrote:
> > Try this patch and let me know if it does the right thing.
> 
> Will do.  I'll report back in a few hours.
> 
> > Although I do
> > still need to dig a bit on the PIT hang issue.
> 
> Any chance this might be related to the APIC issues currently being
> discussed in other threads?

Hmmm. Good thought, I'll have to look into it. It could be that if the
PIT is disabled in favor of the local apic, we'll have to make sure its
not being used as a clocksource.

-john

