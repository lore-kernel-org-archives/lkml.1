Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbZEYBSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbZEYBSb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 21:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbZEYBSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 21:18:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:6677 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbZEYBSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 21:18:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,241,1241420400"; 
   d="scan'208";a="146430947"
Date: Mon, 25 May 2009 09:18:19 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Chris Howie <cdhowie@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>
Subject: Re: Boot problems with 2.6.29.1 - cannot smoothly boot on battery
Message-ID: <20090525011819.GA9805@sli10-desk.sh.intel.com>
References: <3d2f29dc0905180125x5e7ef51dqf10955a3d44336e2@mail.gmail.com> <200905242236.22715.rjw@sisk.pl> <4A19BA09.4050502@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A19BA09.4050502@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 05:20:09AM +0800, H. Peter Anvin wrote:
> Rafael J. Wysocki wrote:
> > On Monday 18 May 2009, Chris Howie wrote:
> >> Folks:
> >>
> >> I've been running 2.6.29.1 for some time and reported an issue to this
> >> mailing list a while ago about the boot process.  I believe I have now
> >> nailed down the one factor that determines whether I see this issue.
> >>
> >> The problem arises only when booting or halting my laptop when there
> >> is no power plugged in, e.g. the system is running on battery.
> >> Sometime after init begins starting services I must hold down a key on
> >> the keyboard to convince it to continue booting, otherwise it just
> >> hangs.  If the system is running on AC then it boots fine.  This same
> >> problem repeats itself during the halt process if running on battery.
> >>
> >> This also happens when resuming a suspend-to-disk image, after loading
> >> the data from the hard drive, but before control is returned to
> >> userspace.  The keyboard has no effect on this hang, presumably
> >> because the kernel is not listening to the keyboard at this point.
> >> When this happens the only solution is to hold the power button and
> >> boot normally instead.
> >>
> >> An issue like this is a serious usability problem for me.  I am
> >> neither a kernel developer nor hacker, my coding skills applying
> >> mostly to userspace applications.  If there is anything you need from
> >> me to help diagnose this problem please let me know.
> >>
> >> I am not subscribed so please CC me on replies.
> > 
> > Let's try to make your report a bit more visible (some CCs added).
> > 
> 
> I presume it boots with "acpi=off"?
if this is a AMD CPU, please check http://bugzilla.kernel.org/show_bug.cgi?id=13233
