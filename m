Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbYKJOmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbYKJOmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 09:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbYKJOmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 09:42:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48644 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbYKJOmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 09:42:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [Bug #11989] Suspend failure on NForce4-based boards due to chanes in stop_machine
Date: Mon, 10 Nov 2008 15:47:20 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera> <wnN9HICUAgP.A.00E.N4zFJB@chimera> <20081110120401.GA15518@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20081110120401.GA15518@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811101547.21325.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 10 of November 2008, Heiko Carstens wrote:
> On Sun, Nov 09, 2008 at 06:59:16PM +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.27.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11989
> > Subject		: Suspend failure on NForce4-based boards due to chanes in stop_machine
> > Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
> > Date		: 2008-11-03 0:28 (7 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c9583e55fa2b08a230c549bd1e3c0bde6c50d9cc
> > References	: http://marc.info/?l=linux-kernel&m=122567187604356&w=4
> 
> Hi Rafael,

Hi,

> could you provide more informations for this, please?
> 
> What is your kernel configuration?

Available at: http://www.sisk.pl/kernel/debug/mainline/2.6.28-rc3/kitty-config

> Do you have any binary only modules (nvidia?) loaded?

No, I don't.

> Is it possible to recreate the bug by e.g. just doing something like
> 
> echo 0 > /sys/devices/system/cpu/cpu1/online

I haven't checked (yet), I'll do that later today and let you know.

> (or any other online cpu)? Or does it trigger any lockdep warnings?

Thanks,
Rafael
