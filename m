Return-Path: <linux-kernel-owner+w=401wt.eu-S1760649AbYHAVIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760649AbYHAVIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760576AbYHAVIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:08:20 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:60848 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760283AbYHAVIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:08:17 -0400
Date: Fri, 01 Aug 2008 17:08:08 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: ACPI OSI disaster on latest HP laptops - critical temperature
 shutdown
In-reply-to: <alpine.LFD.1.10.0807261406230.2958@localhost.localdomain>
X-X-Sender: lenb@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Renninger <trenn@suse.de>, Arjan van de Ven <arjan@linux.intel.com>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       Christian Kornacker <ckornacker@suse.de>
Message-id: <alpine.LFD.1.10.0808011708010.3011@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <200807241727.41715.trenn@suse.de>
 <alpine.LFD.1.10.0807241952270.6098@localhost.localdomain>
 <200807251319.12786.trenn@suse.de> <200807251726.14366.rjw@sisk.pl>
 <alpine.LFD.1.10.0807261406230.2958@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[yet another resend]

On Sat, 26 Jul 2008, Len Brown wrote:

> 
> 
> On Fri, 25 Jul 2008, Rafael J. Wysocki wrote:
> 
> > On Friday, 25 of July 2008, Thomas Renninger wrote:
> > > On Friday 25 July 2008 02:04:32 Len Brown wrote:
> > [--snip--]
> > > 
> > > Len, this is not about the thermal zone, it is just
> > > a real-world example of something I told you will happen
> > > if Linux stays _OSI transparent with Windows.
> > > 
> > > This is about that they have to provide a BIOS hot-fix for
> > > VISTA or VISTA SP and thus breaking Linux because there
> > > is no way to distinguish anymore.
> > > Windows 2007 likely will have that fixed and they provide
> > > a sane _CRT trip point again.
> > > This is an example of Windows versions workarounds that could
> > > get much more complex, like initializing HW differently or
> > > whatever.
> > > _OSI is used by vendors as a convenient possibility to
> > > adjust/workaround Windows bugs in their BIOSes, without
> > > the need to pay Millions to Microsoft to fix their things.
> > 
> > This is a valid point, IMO.
> > 
> > If vendors use _OSI(Windows) to work around Windows bugs, we get broken
> > automatically on those systems unless we put in some DMI-based hacks.
> 
> I belive that the AML Thomas shared does not
> illustrate a Vista bug workaround in a BIOS.
> Rather it is simply a BIOS bug that Vista doesn't catch.
> 
> -Len
> 
> 
