Return-Path: <linux-kernel-owner+w=401wt.eu-S932506AbYBUAdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506AbYBUAdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 19:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbYBUAdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 19:33:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33334 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbYBUAdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 19:33:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: 2.6.25-rc2 regression - hang on suspend
Date: Thu, 21 Feb 2008 01:31:53 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
References: <1203422386.10992.2.camel@localhost> <200802200050.10158.rjw@sisk.pl> <1203487269.6542.1.camel@localhost>
In-Reply-To: <1203487269.6542.1.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802210131.54272.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 20 of February 2008, Soeren Sonnenburg wrote:
> On Wed, 2008-02-20 at 00:50 +0100, Rafael J. Wysocki wrote:
> > On Tuesday, 19 of February 2008, Soeren Sonnenburg wrote:
> > > On Tue, 2008-02-19 at 22:06 +0100, Rafael J. Wysocki wrote:
> > > > On Tuesday, 19 of February 2008, Soeren Sonnenburg wrote:
> > > > > Hi,
> > > > 
> > > > Hi,
> > > > 
> > > > > since 2.6.25-rc1 (first version I tried) and still in rc2 (and git), I
> > > > > see a hang on s2ram already when trying to suspend.
> > > > 
> > > > Does it work with 2.6.24?
> > > 
> > > yes.
> > 
> > Please take the current mainline (there are a couple of nasty bugs fixed in
> > it), configure it with CONFIG_PM_DEBUG set, boot it with "no_console_suspend",
> > run
> > 
> > # echo 8 > /proc/sys/kernel/printk
> > # echo devices > /sys/power/pm_test
> > # echo mem > /sys/power/state
> > 
> > If it hangs, it should leave a stack trace before and I need that trace to see
> > what's going on.  If it doesn't hang, I'll tell you what to do next.
> 
> I tried with 2.6.24.2 with CONFIG_PM_DEBUG set, following your steps and
> yes it works flawlessly (though the display did not come back I could
> suspend/resume multiple times without problems, and finally s2ram -f -p
> brought the display back).

Hm, there's no /sys/power/pm_test in 2.6.24.2 (and the "current mainline"
means the latest -git kernel possible or the current top of the Linus' tree),
so in fact you tested 2.6.24 again, that is known to work ...

Thanks,
Rafael
