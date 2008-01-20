Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbYATKZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbYATKZX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 05:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbYATKZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 05:25:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48960 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920AbYATKY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 05:24:58 -0500
Date: Sun, 20 Jan 2008 11:24:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-mm1: WARN_ON() in clockevents_register_device() on
	HP nx6325
Message-ID: <20080120102440.GA507@elte.hu>
References: <20080117023514.9df393cf.akpm@linux-foundation.org> <200801200210.38412.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801200210.38412.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Something goes wrong in the timers land.  I get this on boot:
> 
> ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> Disabling APIC timer
> ------------[ cut here ]------------
> WARNING: at /home/rafael/src/mm/linux-2.6.24-rc8-mm1/kernel/time/clockevents.c:1
> 65 clockevents_register_device+0x36/0xc4()

ok, since we disable the APIC timer, i suspect this warning can be 
disregarded - the bootup is otherwise fine, right?

Thomas - why do we register it while it's disabled? I have put in that 
warning to detect APIC miscalibrations.

	Ingo
