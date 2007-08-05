Return-Path: <linux-kernel-owner+w=401wt.eu-S1761501AbXHEOZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761501AbXHEOZs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 10:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758028AbXHEOZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 10:25:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:40919 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755278AbXHEOZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 10:25:36 -0400
Subject: Re: ACPI on Averatec 2370
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Cal Peake <cp@absolutedigital.net>, Chuck Ebbert <cebbert@redhat.com>,
       Gabriel C <nix.or.die@googlemail.com>, Frank Hale <frankhale@gmail.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel ACPI Mailing List <linux-acpi@vger.kernel.org>,
       len.brown@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       tim.gardner@canonical.com
In-Reply-To: <20070804093035.GA25389@one.firstfloor.org>
References: <46ACD8DB.2020108@googlemail.com>
	 <Pine.LNX.4.64.0707301048460.5693@lancer.cnet.absolutedigital.net>
	 <Pine.LNX.4.64.0708021335060.28012@lancer.cnet.absolutedigital.net>
	 <46B22BDA.8090604@redhat.com>
	 <Pine.LNX.4.64.0708021512530.28012@lancer.cnet.absolutedigital.net>
	 <46B23E08.4070106@redhat.com>
	 <Pine.LNX.4.64.0708021627590.28012@lancer.cnet.absolutedigital.net>
	 <alpine.LFD.0.999.0708021353320.8184@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0708021723160.28012@lancer.cnet.absolutedigital.net>
	 <alpine.LFD.0.999.0708031447420.8184@woody.linux-foundation.org>
	 <20070804093035.GA25389@one.firstfloor.org>
Content-Type: text/plain
Date: Sun, 05 Aug 2007 16:26:26 +0200
Message-Id: <1186323986.3858.19.camel@fanta4.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-08-04 at 11:30 +0200, Andi Kleen wrote:
> > > amd_apic_timer_broken: forcing return value of 1

> What exact type of machine is it?

FYI: There seem to be a very wide range of Turion machines affected by
the latest no_hz/time/clockevents changes.
Tim Gardner reported a hang while booting and also pointed to commit:
e9e2cdb412412326c4827fc78ba27f410d837e6e
In the thread: ACPI Regression on Dell E1501
http://marc.info/?t=118246118400004&r=1&w=2

I am also seeing the hang Tim reported with a Ferrari F5000
(AMD Turion(tm) 64 X2 Mobile Technology TL-60)
On this machine, the hang only occurs sporadically (about every third
time). It seems, once it could pass a critical init section all is fine?
Hope that helps in some way...

   Thomas

