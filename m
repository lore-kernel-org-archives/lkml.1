Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbYIEJAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbYIEJAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 05:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbYIEJAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 05:00:21 -0400
Received: from mail.suse.de ([195.135.220.2]:40843 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbYIEJAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 05:00:19 -0400
Date: Fri, 5 Sep 2008 11:00:13 +0200
From: Holger Macht <hmacht@suse.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Steven King <sfking@fdwdc.com>, Tomas Carnecky <tom@dbservice.com>,
       Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net
Subject: Re: 2.6.26.[1-3] + x61 tablet + x6ultrabase: no resume
	after?undocking
Message-ID: <20080905090013.GC6891@homac>
Mail-Followup-To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Steven King <sfking@fdwdc.com>, Tomas Carnecky <tom@dbservice.com>,
	Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net
References: <200808301535.22419.sfking@fdwdc.com> <20080901112816.GA21970@khazad-dum.debian.net> <48BBDD2C.5020804@dbservice.com> <200809011205.05253.sfking@fdwdc.com> <20080903144541.GA10978@homac> <20080903212827.GB14620@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080903212827.GB14620@khazad-dum.debian.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 03. Sep - 18:28:27, Henrique de Moraes Holschuh wrote:
> (Holger dropped from CC/To as requested by the mail-followup-to header).
> 
> On Wed, 03 Sep 2008, Holger Macht wrote:
> > On Mon 01. Sep - 12:05:04, Steven King wrote:
> > > On Monday 01 September 2008 5:16:44 Tomas Carnecky wrote:
> > > 
> > > > I just tested suspend/resume with the CDROM drive removed (an empty
> > > > bay). Suspend/resume now works just fine, regardless how I dock/undock
> > > > the laptop.
> > > 
> > > I'm seeing the exact same things as Tom.  Also, in my dmesg I see:
> > > 
> > > ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: found ejectable bay
> > > ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: Adding notify handler
> > > ACPI: Error installing bay notify handler
> > > 
> > > is this significant?
> > 
> > No, it's not. Bay driver is obsolete with 2.6.26's libata hotplug code.
> 
> Hardly so.  We need to be able to query state and command the bay from
> userspace.  We need to support non-libata devices.  We don't need, but want,
> notifications that can be easily flagged by userspace as being related to
> bay/dock ejections and insertions (for OSD).
> 
> What makes bay obsolete is the rework on the dock driver that adds all bay
> functionality to dock.c... and that ain't even on 2.6.27, AFAIK.

Maybe the statement was a little bit harsh, it's just that you won't need
bay in conjunction with libata, because it can't install the notification
handler because that was already done by libata.

Regards,
	Holger
