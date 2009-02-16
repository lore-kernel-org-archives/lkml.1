Return-Path: <linux-kernel-owner+w=401wt.eu-S1757333AbZBPMiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbZBPMiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 07:38:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755162AbZBPMhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 07:37:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59373 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755087AbZBPMhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 07:37:54 -0500
Date: Mon, 16 Feb 2009 13:37:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>, Len Brown <len.brown@intel.com>,
       Thomas Renninger <trenn@suse.de>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: [Bug #12401] 2.6.28 regression: xbacklight broken on ThinkPad
	X61s
Message-ID: <20090216123740.GB7047@elte.hu>
References: <sTyoMUwdm9B.A.QCH.U40lJB@chimera> <ROx6X68CGJG.A.FEB.M50lJB@chimera> <20090215134409.GC21670@srcf.ucam.org> <200902151538.29766.rjw@sisk.pl> <20090215221647.GA15392@dose.home.local> <20090216011600.GA28929@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216011600.GA28929@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Sun, Feb 15, 2009 at 11:16:47PM +0100, Tino Keitel wrote:
> 
> > I think if it works without DRI in 2.6.27 and doesn't work in 2.6.28,
> > it isn't a configuration error, but a real regression.
> 
> It only worked by accident without DRM support, since you were using the 
> ATI codepath in the firmware rather than the Intel one. That bug's been 
> fixed, [...]

Which precise commit ID is that?

> [...] so now you're following the Intel codepath - unfortunately 
> there's no way to do that without kernel-level graphics support, which 
> means DRM.

Tino, does it all work fine if CONFIG_DRM is enabled?

	Ingo
