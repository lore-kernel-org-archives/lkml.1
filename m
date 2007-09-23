Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbXIWT7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbXIWT7w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 15:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbXIWT7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 15:59:44 -0400
Received: from www.osadl.org ([213.239.205.134]:32774 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752255AbXIWT7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 15:59:43 -0400
Subject: Re: 2.6.23-rc4-mm1 and -rc6-mm1: boot failure on HP nx6325,
	related to clockevents
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200709232208.18797.rjw@sisk.pl>
References: <200709231257.12213.rjw@sisk.pl>
	 <1190574641.4035.148.camel@chaos>  <200709232208.18797.rjw@sisk.pl>
Content-Type: text/plain
Date: Sun, 23 Sep 2007 21:59:41 +0200
Message-Id: <1190577581.4035.152.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-09-23 at 22:08 +0200, Rafael J. Wysocki wrote:
> > > Since the boot fails very early, before any messages reach the (VGA) console,
> > > I have no idea what to do next, except for digging in the code.
> > 
> > Ok, lets track it down. Is there any difference when you add:
> > 
> > nohz=off
> > highres=off
> > noapictimer
> > 
> > or any combinations of the above to the kernel command line ?
> 
> First, for now, I build all kernels with NO_HZ and HIGH_RES_TIMERS unset
> (.config for 2.6.23-rc6-mm1 is attached).
> 
> Second, noacpitimer added to the command line makes all of the kernels, up to
> and including 2.6.23-rc6-mm1, boot (this seems to be 100% reproducible).

That's valuable information. Can you please provide a boot log of one of
those with an additional "apic=verbose" on the command line ?

Thanks,

	tglx


