Return-Path: <linux-kernel-owner+w=401wt.eu-S1758319AbYHCRVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319AbYHCRVv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 13:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756682AbYHCRVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 13:21:41 -0400
Received: from mail.suse.de ([195.135.220.2]:49275 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756602AbYHCRVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 13:21:40 -0400
From: Thomas Renninger <trenn@suse.de>
To: Len Brown <lenb@kernel.org>
Subject: Re: ACPI OSI disaster on latest HP laptops - critical temperature shutdown
Date: Sun, 3 Aug 2008 19:23:08 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "linux-acpi" <linux-acpi@vger.kernel.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       Christian Kornacker <ckornacker@suse.de>
References: <200807241727.41715.trenn@suse.de> <alpine.LFD.1.10.0807261406230.2958@localhost.localdomain> <alpine.LFD.1.10.0808011708010.3011@localhost.localdomain>
In-Reply-To: <alpine.LFD.1.10.0808011708010.3011@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808031923.09414.trenn@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 August 2008 11:08:08 pm Len Brown wrote:
> [yet another resend]
>
> On Sat, 26 Jul 2008, Len Brown wrote:
> > On Fri, 25 Jul 2008, Rafael J. Wysocki wrote:
> > > On Friday, 25 of July 2008, Thomas Renninger wrote:
> > > > On Friday 25 July 2008 02:04:32 Len Brown wrote:
> > >
> > > [--snip--]
> > >
> > > > Len, this is not about the thermal zone, it is just
> > > > a real-world example of something I told you will happen
> > > > if Linux stays _OSI transparent with Windows.
> > > >
> > > > This is about that they have to provide a BIOS hot-fix for
> > > > VISTA or VISTA SP and thus breaking Linux because there
> > > > is no way to distinguish anymore.
> > > > Windows 2007 likely will have that fixed and they provide
> > > > a sane _CRT trip point again.
If Windows is returning true for all ever existing OSI(Windows XY) versions as 
Linux is doing it and they stick to that in the future, then my above 
assumption is not true.

Thanks to Matthew Garret pointing to the relevant Microsoft documentation.

> > > > This is an example of Windows versions workarounds that could
> > > > get much more complex, like initializing HW differently or
> > > > whatever.
> > > > _OSI is used by vendors as a convenient possibility to
> > > > adjust/workaround Windows bugs in their BIOSes, without
> > > > the need to pay Millions to Microsoft to fix their things.

If the next Windows version also returns true for the one for which the 
workaround applies to, they have to take care that only the one OS is 
matching in a follow up update, e.g.:
And(brokenOS, !new_OSes)
So this should make half way sure that vendors do not mis-use this too often.
Also it is ensured that the next Linux kernel generation returning 
OSI(newOSes) will get the correct AML code again.

And distributions can still offer OSI(supported dist) for emergencies.

Sorry for the loud noise.
I am convinced now that it is not that bad as it first looked like.

Thanks for all the input/feedback,

          Thomas
