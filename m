Return-Path: <linux-kernel-owner+w=401wt.eu-S1757013AbZCWAMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013AbZCWAMo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 20:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbZCWAMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 20:12:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:60561 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbZCWAMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 20:12:33 -0400
Subject: Re: [RFC][PATCH 0/2] Make radeonfb use PCI PM core for suspendig
 device (was: Re: [RFC][PATCH] PCI PM: Be extra careful when changing power
 states of devices)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200903222208.22434.rjw@sisk.pl>
References: <200903210003.55161.rjw@sisk.pl>
	 <200903222208.22434.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 11:09:02 +1100
Message-Id: <1237766942.25062.680.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-22 at 22:08 +0100, Rafael J. Wysocki wrote:
> On Saturday 21 March 2009, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > The story in http://bugzilla.kernel.org/show_bug.cgi?id=12846 shows
> > that setting the power state of a PCI device by
> > pci_raw_set_power_state() may sometimes fail.  For this reason,
> > pci_raw_set_power_state() should not assume that the power state of
> > the device has actually changed after writing into its PMCSR.
> > Instead, it should read the value from there and use it to update
> > dev->current_state.  It also is useful to print a warning if the
> > device's power state hasn't changed as expected.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> OK, since the Ben's radeonfb fix for bug #12846 has been merged, I'd like
> to do something a bit different.
> 
> Patch 1/2 introduces __pci_set_power_state() that will allow the radeonfb
> driver not to open code PCI PM operations.
> 
> Patch 2/2 makes the driver use __pci_set_power_state().
> 
> Comments welcome.

No objection.

Ben.


