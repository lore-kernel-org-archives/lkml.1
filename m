Return-Path: <linux-kernel-owner+w=401wt.eu-S934197AbXCVTgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934197AbXCVTgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 15:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933166AbXCVTgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 15:36:06 -0400
Received: from www.osadl.org ([213.239.205.134]:33326 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934198AbXCVTgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 15:36:05 -0400
Subject: Re: [BUG] no boot with 2.6.21-rc3 and later
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: john stultz <johnstul@us.ibm.com>
Cc: Bob Tracy <rct@gherkin.frus.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, bunk@stusta.de, jikos@jikos.cz
In-Reply-To: <1174591552.5662.8.camel@localhost.localdomain>
References: <20070322191410.ECCBFDBA1@gherkin.frus.com>
	 <1174591552.5662.8.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 20:43:22 +0100
Message-Id: <1174592602.10840.222.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-22 at 12:25 -0700, john stultz wrote:
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

Ouch, yes. That's fatal and can happen. Not sure, what to do about that.

	tglx


