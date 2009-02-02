Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbZBBW3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbZBBW3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 17:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbZBBW3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 17:29:06 -0500
Received: from gate.crashing.org ([63.228.1.57]:42129 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbZBBW3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 17:29:05 -0500
Subject: Re: PCI PM: Restore standard config registers of all devices early
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>
In-Reply-To: <200902022239.02453.rjw@sisk.pl>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>
	 <alpine.LFD.2.00.0902021241430.3247@localhost.localdomain>
	 <alpine.LFD.2.00.0902021251130.3247@localhost.localdomain>
	 <200902022239.02453.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 09:28:42 +1100
Message-Id: <1233613722.18767.119.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 22:39 +0100, Rafael J. Wysocki wrote:
> Yes, which is why I thought it might be a good idea to make the AML interpreter
> allow is to execute AML with interrupts off, so that we can put devices into
> low power states and/or put them into D0 with interrupts off.
> 
> Then, we'll be able to make ACPI happy (up to some strange ordering
> expectations of some insane BIOSes maybe) and fix the interrupts issue at
> the same time.
> 
> The idea would be to have a special code path(s) where AML can be executed
> with interrupts off and a couple of special entry points into the AML
> interpreter for this purpose.

Right. That way, I can also use the same hooks for my clock gating and
be confident they'll be called at the right time.

Now, we need some ACPI folks to tell us why this won't work :-)

Ben.


