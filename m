Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbYBDMGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbYBDMGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 07:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbYBDMGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 07:06:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44569 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbYBDMGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 07:06:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 9884] using the attached config hangs the kernel at boot
Date: Mon, 4 Feb 2008 13:04:19 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Shaohua Li <shaohua.li@intel.com>, plamen.petrov@tk.ru.acad.bg,
       LKML <linux-kernel@vger.kernel.org>
References: <20080204115803.450AF108018@picon.linux-foundation.org>
In-Reply-To: <20080204115803.450AF108018@picon.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802041304.20680.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 4 of February 2008, bugme-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=9884
> 
> ------- Comment #3 from anonymous@kernel-bugs.osdl.org  2008-02-04 03:58 -------
> Reply-To: akpm@linux-foundation.org
> 
> On Mon,  4 Feb 2008 03:33:58 -0800 (PST) bugme-daemon@bugzilla.kernel.org
> wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=9884
> > 
> >            Summary: using the attached config hangs the kernel at boot
> >            Product: Power Management
> >            Version: 2.5
> >      KernelVersion: linux-2.6.24-git13
> >           Platform: All
> >         OS/Version: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: blocking
> >           Priority: P1
> >          Component: Other
> >         AssignedTo: power-management_other@kernel-bugs.osdl.org
> >         ReportedBy: plamen.petrov@tk.ru.acad.bg
> > 
> > 
> > Latest working kernel version: linux-2.6.24-git9
> > Earliest failing kernel version: linux-2.6.24-git13
> > Distribution: Bluewhite64 12
> > Hardware Environment: Sempron 3200+, nForce 450 chipset, 512MB RAM
> > Software Environment:
> > Problem Description: kernel hangs at boot
> > 
> > Steps to reproduce: use linux-2.6.24-git13 with attached config;
> > (not sure if it is related, but with git9 the nforce NIC appeared to use
> > PCIe/MSI)
> 
> hm, I haven't seen that PCIEASPM crash before.  I think Greg's going to
> revert the whole lot.

I have.  In fact, I can reproduce it myself, on the nx6325.

> Meanwhile, please set CONFIG_PCIEASPM.

Surely unset?
