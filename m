Return-Path: <linux-kernel-owner+w=401wt.eu-S1752888AbYANPBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbYANPBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 10:01:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750932AbYANPBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 10:01:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53082 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbYANPBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 10:01:21 -0500
Date: Mon, 14 Jan 2008 16:01:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Adrian Bunk <bunk@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       rjw@sisk.pl, pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without
	HOTPLUG_CPU
Message-ID: <20080114150103.GA2700@elte.hu>
References: <20080103442.621670000@suse.de> <20080110111514.GS25945@bingen.suse.de> <20080110112607.GE28740@does.not.exist> <200801101242.53504.ak@suse.de> <20080110124702.GF28740@does.not.exist> <p73fxx5omck.fsf@bingen.suse.de> <20080110150911.GG28740@does.not.exist> <20080114135240.GA15357@elte.hu> <20080114140910.GA8507@uranus.ravnborg.org> <20080114145854.GA31695@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114145854.GA31695@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > Would be great to have them automated - just dunno how to do it. Do 
> > you see a feasible way to do it?
> 
> a good starting point would be to make the warnings a lot more 
> self-explanatory. Right now it's often non-obvious trying to figure 
> out how the dependencies are structured and which one should be 
> changed to get rid of the bug.

for example, in current -git, could you tell me why this triggers:

 WARNING: vmlinux.o(.text+0x87e2a): Section mismatch: reference to 
          .init.text: (between 'process_zones' and 'setup_per_cpu_pageset')

and how to resolve it? I had a quick look and it was not obvious to me.

	Ingo
