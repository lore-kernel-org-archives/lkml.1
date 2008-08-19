Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbYHSRAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbYHSRAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 13:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbYHSRAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 13:00:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53460 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbYHSRAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 13:00:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Langsdorf, Mark" <mark.langsdorf@amd.com>
Subject: Re: [Regression] 2.6.27-rc2-git4: suspend and power off fails on Asus M3A32-MVP
Date: Tue, 19 Aug 2008 19:03:29 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Dave Jones" <davej@redhat.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>, kernel-testers@vger.kernel.org,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Arnold, Frank" <Frank.Arnold@amd.com>
References: <200808092321.16711.rjw@sisk.pl> <6453C3CB8E2B3646B0D020C112613273C5AC60@sausexmb4.amd.com>
In-Reply-To: <6453C3CB8E2B3646B0D020C112613273C5AC60@sausexmb4.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808191903.30437.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 12 of August 2008, Langsdorf, Mark wrote:
> 
> > Unfortunately, your commit 34ae7f35a21694aa5cb8829dc5142c39d73d6ba0
> > ("[CPUFREQ][2/2] preregister support for powernow-k8") causes 
> > a power off/
> > suspend/ hibernation regression on my test box with the Asus M3A32-MVP
> > mainboard (AMD 790 chipset) and the Phenom 9850 CPU.
> > 
> > Apparently, the patch causes a crash in a CPU hotplug 
> > notifier to happen, but I'm not really sure of that, since there are a
> lot of stack 
> > traces resulting from it and I'm unable to capture them over a serial
> console.
> > 
> > It is sufficient to revert commit 
> > 34ae7f35a21694aa5cb8829dc5142c39d73d6ba0 to
> > make things work again.
> 
> Thanks for the clear report.  I'll look into it and try to fix it.

Any news?

Rafael
