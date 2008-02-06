Return-Path: <linux-kernel-owner+w=401wt.eu-S1763519AbYBFB7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763519AbYBFB7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 20:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760063AbYBFB7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 20:59:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:45006 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758793AbYBFB7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 20:59:08 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH for review] ACPI: Create /sys/firmware/acpi/interrupts/ counters
Date: Tue, 5 Feb 2008 20:58:50 -0500
User-Agent: KMail/1.9.5
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200802050230.10873.lenb@kernel.org> <200802051812.09228.lenb@kernel.org> <20080205231842.GB8740@suse.de>
In-Reply-To: <20080205231842.GB8740@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802052058.50663.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 February 2008 18:18, Greg KH wrote:
> On Tue, Feb 05, 2008 at 06:12:09PM -0500, Len Brown wrote:
> > On Tuesday 05 February 2008 17:18, Greg KH wrote:
> > > On Tue, Feb 05, 2008 at 02:30:10AM -0500, Len Brown wrote:
> > > > # cat /sys/firmware/acpi/interrupts/summary
> > > > pm_timer     0
> > > > glbl_lock    0
> > > > power_btn    0
> > > > sleep_btn    0
> > > > rtc          0
> > > > gpe00    0
> > ...
> > > > gpe1F    0
> > > > gpe_hi    0
> > > > gpe_total   63
> > > > acpi_irq    63
> > > 
> > > Eeek!  Why?  What's wrong with individual files here?
> > 
> > My expectation is that this is a shell interface for debugging,
> > not an API for programs.  ala /proc/interrupts.
> 
> Great, then use debugfs for it.  Please, don't put debug stuff like this
> in sysfs, that's not what it is there for.  You can do whatever you want
> in debugfs :)

Can you point to a model of good behaviour that I can copy?

note that I want this information to be available on every system,
just like /proc/interrupts is.

/proc/ has seqfile support, is there a reason I shouldn't use it?
I'd banned additional files from /proc/acpi for a long time
since the directory layout was ill-conceived.  But maybe I
should re-consider the headlong rush to use sysfs?

thanks,
-Len
