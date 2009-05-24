Return-Path: <linux-kernel-owner+w=401wt.eu-S1753090AbZEXUg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbZEXUg0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 16:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbZEXUgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 16:36:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33801 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbZEXUgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 16:36:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chris Howie <cdhowie@gmail.com>
Subject: Re: Boot problems with 2.6.29.1 - cannot smoothly boot on battery
Date: Sun, 24 May 2009 22:36:21 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Anvin" <hpa@zytor.com>,
       Greg KH <gregkh@suse.de>
References: <3d2f29dc0905180125x5e7ef51dqf10955a3d44336e2@mail.gmail.com>
In-Reply-To: <3d2f29dc0905180125x5e7ef51dqf10955a3d44336e2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905242236.22715.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 May 2009, Chris Howie wrote:
> Folks:
> 
> I've been running 2.6.29.1 for some time and reported an issue to this
> mailing list a while ago about the boot process.  I believe I have now
> nailed down the one factor that determines whether I see this issue.
> 
> The problem arises only when booting or halting my laptop when there
> is no power plugged in, e.g. the system is running on battery.
> Sometime after init begins starting services I must hold down a key on
> the keyboard to convince it to continue booting, otherwise it just
> hangs.  If the system is running on AC then it boots fine.  This same
> problem repeats itself during the halt process if running on battery.
> 
> This also happens when resuming a suspend-to-disk image, after loading
> the data from the hard drive, but before control is returned to
> userspace.  The keyboard has no effect on this hang, presumably
> because the kernel is not listening to the keyboard at this point.
> When this happens the only solution is to hold the power button and
> boot normally instead.
> 
> An issue like this is a serious usability problem for me.  I am
> neither a kernel developer nor hacker, my coding skills applying
> mostly to userspace applications.  If there is anything you need from
> me to help diagnose this problem please let me know.
> 
> I am not subscribed so please CC me on replies.

Let's try to make your report a bit more visible (some CCs added).

Best,
Rafael
