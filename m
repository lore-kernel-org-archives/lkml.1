Return-Path: <linux-kernel-owner+w=401wt.eu-S1764088AbYBTGBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764088AbYBTGBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 01:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbYBTGBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 01:01:15 -0500
Received: from nn7.de ([85.214.94.156]:40877 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753945AbYBTGBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 01:01:15 -0500
Subject: Re: 2.6.25-rc2 regression - hang on suspend
From: Soeren Sonnenburg <kernel@nn7.de>
To: "Rafael J\. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200802200050.10158.rjw@sisk.pl>
References: <1203422386.10992.2.camel@localhost>
	 <200802192206.13350.rjw@sisk.pl> <1203458394.28475.7.camel@localhost>
	 <200802200050.10158.rjw@sisk.pl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 20 Feb 2008 07:01:09 +0100
Message-Id: <1203487269.6542.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-02-20 at 00:50 +0100, Rafael J. Wysocki wrote:
> On Tuesday, 19 of February 2008, Soeren Sonnenburg wrote:
> > On Tue, 2008-02-19 at 22:06 +0100, Rafael J. Wysocki wrote:
> > > On Tuesday, 19 of February 2008, Soeren Sonnenburg wrote:
> > > > Hi,
> > > 
> > > Hi,
> > > 
> > > > since 2.6.25-rc1 (first version I tried) and still in rc2 (and git), I
> > > > see a hang on s2ram already when trying to suspend.
> > > 
> > > Does it work with 2.6.24?
> > 
> > yes.
> 
> Please take the current mainline (there are a couple of nasty bugs fixed in
> it), configure it with CONFIG_PM_DEBUG set, boot it with "no_console_suspend",
> run
> 
> # echo 8 > /proc/sys/kernel/printk
> # echo devices > /sys/power/pm_test
> # echo mem > /sys/power/state
> 
> If it hangs, it should leave a stack trace before and I need that trace to see
> what's going on.  If it doesn't hang, I'll tell you what to do next.

I tried with 2.6.24.2 with CONFIG_PM_DEBUG set, following your steps and
yes it works flawlessly (though the display did not come back I could
suspend/resume multiple times without problems, and finally s2ram -f -p
brought the display back).

So what next?

Soeren
