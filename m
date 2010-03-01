Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab0CAUAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 15:00:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34003 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043Ab0CAUAe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 15:00:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug 15289] Regression 2.6.32 -> 2.6.33, Kernel needs a helping key to boot :)
Date: Mon, 1 Mar 2010 21:03:00 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-git-rjw; KDE/4.3.5; x86_64; ; )
Cc: bugzilla-daemon@bugzilla.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <bug-15289-10028@http.bugzilla.kernel.org/> <201003010617.o216HBix024914@demeter.kernel.org>
In-Reply-To: <201003010617.o216HBix024914@demeter.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003012103.00609.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Swithing to e-mail, please keep bugzilla-daemon in the CC list.]

On Monday 01 March 2010, bugzilla-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=15289
> 
> --- Comment #30 from Asbjørn Sannes <kernelbugzilla@sannes.org>  2010-03-01 06:17:06 ---
> hm, so from what I have gathered the previously bisected commit only exposes
> another bug (hidden by enabling hpet). So I started bisecting again, this time
> with hpet=disabled all the way and found:
> 
> commit aa276e1cafb3ce9d01d1e837bcd67e92616013ac
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Mon Jun 9 19:15:00 2008 +0200
> 
> x86, clockevents: add C1E aware idle function
> 
> Reverting this from a non-working 2.6.27 makes it work also. Things have
> changed considerably since then so I was not able to revert it from the newest
> kernel.
> 
> Maybe that disabling of SBX00 hpet msi, only should be done when you do
> actually have floppy support? Makes more people boot atleast :P

Thomas, it looks like something's missing in our C1E handling.  Can you have
a look at this bug report, please?

Rafael
