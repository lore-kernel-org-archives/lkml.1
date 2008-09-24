Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbYIXIAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbYIXIAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 04:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbYIXIAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 04:00:06 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:43880 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbYIXIAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 04:00:04 -0400
Date: Wed, 24 Sep 2008 03:59:41 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: linux-next: Tree for August 14 (sysfs/acpi errors)
In-reply-to: <200808171513.13611.rusty@rustcorp.com.au>
X-X-Sender: lenb@localhost.localdomain
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@linux.intel.com>, Greg KH <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Message-id: <alpine.LFD.1.10.0809240353520.20067@localhost.localdomain>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_H9obFDc2QoKEqqFKVZFpRQ)"
References: <20080814172945.250a27f2.sfr@canb.auug.org.au>
 <20080816044714.GA19886@kroah.com> <48A78D4A.70609@linux.intel.com>
 <200808171513.13611.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_H9obFDc2QoKEqqFKVZFpRQ)
Content-type: TEXT/PLAIN; charset=UTF-8
Content-transfer-encoding: 8BIT



On Sun, 17 Aug 2008, Rusty Russell wrote:

> On Sunday 17 August 2008 12:30:34 Andi Kleen wrote:
> > Greg KH wrote:
> > > On Sat, Aug 16, 2008 at 05:48:26AM +0200, Andi Kleen wrote:
> > >>> They have been module options, not prefixed kernel parameters so far,
> > >>> and the prefix was just the module name.
> > >>> So it just strikes back, that acpi uses generic names for the modules,
> > >>> there would have been no problem if "power" would be called
> > >>> "acpi_power" and the options would just be ﻿"acpi.acpica_version" and
> > >>> "acpi_power.nocheck".

I think we (all) agree that we should keep the acpi gunk together,
rather than creating namespace sprawl to satisfy the current sysfs code.

> > >>> But well, there are driver modules just called "option", so acpi is not
> > >>> that bad. :)
> > >>>
> > >>>> I think the generic params code should be fixed to handle this.
> > >>>
> > >>> We could try to look up existing directories to use instead of
> > >>> expecting that we need to create and own them. I guess,
> > >>
> > >> sysfs does this anyways, doesn't it. We would just need to teach it
> > >> to not BUG() in this case, perhaps with a special entry point.
> > >> Also a BUG() in general seems a little harsh for this, surely a WARN_ON
> > >> should be enough.
> > >
> > > It is a WARN() call, not a BUG().
> >
> > Ok. Can we remove it? Or add a new entry point that allows to disable it?
> >
> > I don't think relying on link order like Rusty proposes is a good long term
> > solution.
>
> To be clear, I agree with Andi.  If this is for current kernel I'd just fix 
> link order, for longer term we need something cleverer.

This problem first shows up with the addition of the
acpi.power_nocheck modparam, which is staged for 2.6.28.
Is 2.6.28 "current" or longer term?

thanks,
-Len


--Boundary_(ID_H9obFDc2QoKEqqFKVZFpRQ)--
