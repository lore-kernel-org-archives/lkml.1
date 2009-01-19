Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132AbZASVgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbZASVgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 16:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755877AbZASVgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 16:36:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39743 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755702AbZASVgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 16:36:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/6] Hibernation: Introduce system_entering_hibernation
Date: Mon, 19 Jan 2009 22:35:22 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: Jeff Garzik <jeff@garzik.org>, Frans Pop <elendil@planet.nl>,
       tj@kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20081104062734.GA4420@havoc.gtf.org> <200901192054.55536.rjw@sisk.pl> <20090119212428.GB6194@nowhere>
In-Reply-To: <20090119212428.GB6194@nowhere>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901192235.23677.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 January 2009, Frederic Weisbecker wrote:
> On Mon, Jan 19, 2009 at 08:54:54PM +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Introduce boolean function system_entering_hibernation() returning
> > 'true' during the last phase of hibernation, in which devices are
> > being put into low power states and the sleep state (for example,
> > ACPI S4) is finally entered.
> > 
> > Some device drivers need such a function to check if the system is
> > in the final phase of hibernation.  In particular, some SATA drivers
> > are going to use it for blacklisting systems in which the disks
> > should not be spun down during the last phase of hibernation (the
> > BIOS will do that anyway).
> >
> 
> Hi Rafael,
> 
> Why not using the power event notifier?

I'm not sure what you mean exactly, care to elaborate?

Anyway, however, this is a pretty old patch series and I'm not very much
interested in reworking it once again.  If you think it can be made better,
please go on. :-)

Thanks,
Rafael
