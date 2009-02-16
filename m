Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbZBPJLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbZBPJLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 04:11:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbZBPJK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 04:10:58 -0500
Received: from gate.crashing.org ([63.228.1.57]:47234 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbZBPJK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 04:10:57 -0500
Subject: Re: [Bug #12667] Badness at kernel/time/timekeeping.c:98 in pmud
 (timekeeping_suspended)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Paul Collins <paul@burly.ondioline.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <87hc2u26m5.fsf@burly.wgtn.ondioline.org>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
	 <sWhNs83kKPE.A.p4D.L20jJB@chimera>
	 <878wognj00.fsf@burly.wgtn.ondioline.org> <200902142342.59186.rjw@sisk.pl>
	 <87hc2u26m5.fsf@burly.wgtn.ondioline.org>
Content-Type: text/plain
Date: Mon, 16 Feb 2009 20:10:10 +1100
Message-Id: <1234775410.26036.122.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-16 at 20:17 +1300, Paul Collins wrote:
> It turns out I didn't test this properly.  The warning is only
> triggered
> when I close and open the lid, not when I run 'snooze' to suspend and
> hit Return to resume, as I did for my so-called testing of 2.6.29-rc4.
> 
> Whatever is triggering the warning is still present in 2.6.29-rc5.

Right, we probably need to stop sending input events from the PMU driver
when it's "suspended".

Ping me if I don't produce a patch tomorrow (ie, I forgot :-)

Cheers,
Ben.

