Return-Path: <linux-kernel-owner+w=401wt.eu-S1764302AbYBZVm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764302AbYBZVm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:42:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754590AbYBZVmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:42:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39048 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbYBZVms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:42:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Karsten Wiese <fzu@wemgehoertderstaat.de>
Subject: Re: 2.6.25-rc2 rcupreempt WARN after suspend to ram
Date: Tue, 26 Feb 2008 22:41:36 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>
References: <200802231341.02597.fzu@wemgehoertderstaat.de> <20080224182800.GA10194@linux.vnet.ibm.com> <200802260309.36360.fzu@wemgehoertderstaat.de>
In-Reply-To: <200802260309.36360.fzu@wemgehoertderstaat.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802262241.37038.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 26 of February 2008, Karsten Wiese wrote:
> Am Sonntag, 24. Februar 2008 schrieb Paul E. McKenney:
> > On Sun, Feb 24, 2008 at 04:38:15PM +0100, Karsten Wiese wrote:
> > > Am Samstag, 23. Februar 2008 schrieb Karsten Wiese:
> > > > Am Samstag, 23. Februar 2008 schrieb Paul E. McKenney:
> > > > > On Sat, Feb 23, 2008 at 01:41:02PM +0100, Karsten Wiese wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > This appeared in dmesg after
> > > > > > 	$ echo core > /sys/power/pm_test
> > > > > > followed by 3 cycles of
> > > > > > 	$ echo mem > /sys/power/state
> > > > > > . .config attached.
> > > > > > 
> > > > > > dmesg excerpt (, full ~1MByte available):
> > > > > 
> > > > > Does this tree have http://lkml.org/lkml/2008/1/29/208 applied?
> > > > 
> > > > Yes. This tree was linus' git head as of yesterday or the day before.
> > > 
> > > Updated to git-head of today, same test and .config, different symptoms
> > > like in this thread: http://lkml.org/lkml/2008/2/23/260
> > > Later in this thread, Alan Cox said it looked like irq problems.
> > > Maybe also the rcupreemt related WARN_ON I saw are caused by irq problems.
> > 
> > Might be, but am taking a closer look at the interaction between irq,
> > dynticks, and rcupreempt in any case.
> 
> [Added Rafael, Thomas and Steven to CC]
> 
> The "different symptoms" above are indeed unrelated and solved by reverting
> 	"commit 559bbe6cbd0d8c68d40076a5f7dc98e3bf5864b2
>     	 power_state: get rid of write-only variable in SATA"

This commit has been reverted from the mainline.

Thanks,
Rafael
