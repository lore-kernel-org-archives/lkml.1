Return-Path: <linux-kernel-owner+w=401wt.eu-S1758729AbYBWCIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbYBWCIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 21:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbYBWCIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 21:08:35 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751636AbYBWCIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 21:08:34 -0500
Date: Fri, 22 Feb 2008 18:07:56 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Jesse Barnes <jesse.barnes@intel.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       Romano Giannetti <romano@dea.icai.upcomillas.es>,
       Dave Airlie <airlied@linux.ie>, Greg KH <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: i915 hibernation patch (was: Re: [Suspend-devel] 2.6.25-rc2
 System no longer powers off aftersuspend-to-disk. Screen becomes green.)
In-Reply-To: <200802230255.54510.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.00.0802221805540.21332@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802230031.20292.rjw@sisk.pl> <alpine.LFD.1.00.0802221653000.21332@woody.linux-foundation.org> <200802230255.54510.rjw@sisk.pl>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 23 Feb 2008, Rafael J. Wysocki wrote:
> 
> In the revised patch below I redefined the PM_EVENT_* things as flags so
> that I can "or" them and defined PM_EVENT_SLEEP in analogy with
> CONFIG_PM_SLEEP.

Ok, looks fine by me.

> > Didn't you miss the apci_pci_choose_state() thing that also needs this 
> > extension?
> 
> No, I didn't.  That one operates on the ACPI D* states.

Ok. I consider that just about the worst interface ever, but whatever...

> OK, please have a look at the modified patch below.

All right, I'm fine with it. Now we just need to confirm that it works for 
people..

		Linus
