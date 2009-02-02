Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbZBBWeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbZBBWeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 17:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbZBBWeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 17:34:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35557 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbZBBWeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 17:34:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: PCI PM: Restore standard config registers of all devices early
Date: Mon, 2 Feb 2009 23:33:50 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <200902022249.32452.rjw@sisk.pl> <alpine.LFD.2.00.0902021413040.3247@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902021413040.3247@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902022333.51017.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 February 2009, Linus Torvalds wrote:
> 
> On Mon, 2 Feb 2009, Rafael J. Wysocki wrote:
> > 
> > I think it would be easier to make ACPI allow us to run AML with interrupts
> > off.
> 
> Well, I'd agree, except I have this strong memory of us having known bugs 
> with ACPI turning hard-interrupts on again. Similarly, it uses mutexes etc 
> that simply don't work with interrupts off and/or may turn them on again 
> thanks to scheduling.
> 
> "Fixing" that seems not very easy. ACPI has a bad habit of being _really_ 
> hard to fix in this area.
> 
> I do agree that _if_ we can just fix ACPI, we wouldn't have these issues, 
> and we should  just call it with interrupts disabled with our existing 
> code. But my previous email was a "maybe we can do it like this" kind of 
> thing, which might allow us to use ACPI with none of the irq-off issues.

Well, I think both will be difficult, this way or another. :-)

I'll have a look at the ACPI thing.

Thanks,
Rafael
