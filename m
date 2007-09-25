Return-Path: <linux-kernel-owner+w=401wt.eu-S1760187AbXIYVZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760187AbXIYVZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 17:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbXIYVYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 17:24:55 -0400
Received: from www.osadl.org ([213.239.205.134]:43875 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753970AbXIYVYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 17:24:55 -0400
Subject: Re: 2.6.23-rc4-mm1 and -rc6-mm1: boot failure on HP nx6325,
	related to clockevents
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200709252328.54843.rjw@sisk.pl>
References: <200709231257.12213.rjw@sisk.pl>
	 <200709252207.02532.rjw@sisk.pl> <1190753192.17409.62.camel@chaos>
	 <200709252328.54843.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 23:24:53 +0200
Message-Id: <1190755493.17409.72.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

On Tue, 2007-09-25 at 23:28 +0200, Rafael J. Wysocki wrote:
> > I'm a bit confused by your earlier confirmation, that mainline w/o the
> > -hrt patches boots fine, when you add "apicmaintimer" to the kernel
> > command line. "apicmaintimer" stops the PIT like we do in -hrt and we
> > just use the local APIC timer for everything. Can you please retest and
> > confirm that this is correct ?
> 
> No, it's not.  The mainline _usually_ doesn't boot with "apicmaintimer".
> 
> It seems to me that _sometimes_ the CPU just doesn't enter this C1E state
> and then everything goes fine ...

I'm relieved. I really started to go nuts on this contradicting
patterns.

Your box seems to be worse than the VAIO, it has some random surprise
generator built in :)

> > Is the 32 bit kernel working on that box ?
> 
> Can't tell, I have only 64-bit userland here.

Should be fine. The check is there since late 2.6.21-rc. I really could
kick my own ass that I did not remember the nx6325 wreckage in the
2.6.21-rc time frame. Sigh, way too much broken hardware out there to
keep track of it.

> > Thanks for your patience.
> 
> Well, I'm only making sure that future kernels will run on my box. ;-)

Nothing wrong with that. Thanks again for your help,

	tglx


