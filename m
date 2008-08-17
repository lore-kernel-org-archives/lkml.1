Return-Path: <linux-kernel-owner+w=401wt.eu-S1752727AbYHQFN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbYHQFN1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 01:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbYHQFNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 01:13:18 -0400
Received: from ozlabs.org ([203.10.76.45]:41768 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbYHQFNR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 01:13:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@linux.intel.com>
Subject: Re: linux-next: Tree for August 14 (sysfs/acpi errors)
Date: Sun, 17 Aug 2008 15:13:13 +1000
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
References: <20080814172945.250a27f2.sfr@canb.auug.org.au> <20080816044714.GA19886@kroah.com> <48A78D4A.70609@linux.intel.com>
In-Reply-To: <48A78D4A.70609@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808171513.13611.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 August 2008 12:30:34 Andi Kleen wrote:
> Greg KH wrote:
> > On Sat, Aug 16, 2008 at 05:48:26AM +0200, Andi Kleen wrote:
> >>> They have been module options, not prefixed kernel parameters so far,
> >>> and the prefix was just the module name.
> >>> So it just strikes back, that acpi uses generic names for the modules,
> >>> there would have been no problem if "power" would be called
> >>> "acpi_power" and the options would just be ﻿"acpi.acpica_version" and
> >>> "acpi_power.nocheck".
> >>> But well, there are driver modules just called "option", so acpi is not
> >>> that bad. :)
> >>>
> >>>> I think the generic params code should be fixed to handle this.
> >>>
> >>> We could try to look up existing directories to use instead of
> >>> expecting that we need to create and own them. I guess,
> >>
> >> sysfs does this anyways, doesn't it. We would just need to teach it
> >> to not BUG() in this case, perhaps with a special entry point.
> >> Also a BUG() in general seems a little harsh for this, surely a WARN_ON
> >> should be enough.
> >
> > It is a WARN() call, not a BUG().
>
> Ok. Can we remove it? Or add a new entry point that allows to disable it?
>
> I don't think relying on link order like Rusty proposes is a good long term
> solution.

To be clear, I agree with Andi.  If this is for current kernel I'd just fix 
link order, for longer term we need something cleverer.

Cheers,
Rusty.
