Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbZFCXAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbZFCXAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 19:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbZFCXA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 19:00:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41141 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578AbZFCXA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 19:00:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [Bug #13306] hibernate slow on _second_ run
Date: Thu, 4 Jun 2009 01:00:34 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jan Scholz <scholz@fias.uni-frankfurt.de>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera> <200906032210.54854.rjw@sisk.pl> <1244067926.27194.35.camel@pasglop>
In-Reply-To: <1244067926.27194.35.camel@pasglop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906040100.35254.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 June 2009, Benjamin Herrenschmidt wrote:
> On Wed, 2009-06-03 at 22:10 +0200, Rafael J. Wysocki wrote:
> > Apparently, we have two hibernation and suspend bugs on macbooks
> > related to suspend_device_irqs() and resume_device_irqs(), the other
> > one is
> > (http://bugzilla.kernel.org/show_bug.cgi?id=13407) and I have no idea
> > what's
> > up.
> 
> The other one is a _powerbook_ bug, very different machine (powerpc
> mac). macbooks are just almost ordinary x86 gear :-)

Yes, I realized they were different.

> I'll try to tackle the trackpad problem.

Perhaps the VIA-PMU interrupt shouldn't be disabled in
suspend_device_irqs()?

Best,
Rafael
