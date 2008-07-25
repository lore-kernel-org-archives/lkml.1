Return-Path: <linux-kernel-owner+w=401wt.eu-S1752248AbYGYPYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbYGYPYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 11:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbYGYPYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 11:24:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49241 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbYGYPYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 11:24:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Renninger <trenn@suse.de>
Subject: Re: ACPI OSI disaster on latest HP laptops - critical temperature shutdown
Date: Fri, 25 Jul 2008 17:26:13 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
       "linux-acpi" <linux-acpi@vger.kernel.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       Christian Kornacker <ckornacker@suse.de>
References: <200807241727.41715.trenn@suse.de> <alpine.LFD.1.10.0807241952270.6098@localhost.localdomain> <200807251319.12786.trenn@suse.de>
In-Reply-To: <200807251319.12786.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807251726.14366.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 25 of July 2008, Thomas Renninger wrote:
> On Friday 25 July 2008 02:04:32 Len Brown wrote:
[--snip--]
> 
> Len, this is not about the thermal zone, it is just
> a real-world example of something I told you will happen
> if Linux stays _OSI transparent with Windows.
> 
> This is about that they have to provide a BIOS hot-fix for
> VISTA or VISTA SP and thus breaking Linux because there
> is no way to distinguish anymore.
> Windows 2007 likely will have that fixed and they provide
> a sane _CRT trip point again.
> This is an example of Windows versions workarounds that could
> get much more complex, like initializing HW differently or
> whatever.
> _OSI is used by vendors as a convenient possibility to
> adjust/workaround Windows bugs in their BIOSes, without
> the need to pay Millions to Microsoft to fix their things.

This is a valid point, IMO.

If vendors use _OSI(Windows) to work around Windows bugs, we get broken
automatically on those systems unless we put in some DMI-based hacks.

Thanks,
Rafael
