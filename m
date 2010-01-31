Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904Ab0AaCpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab0AaCpz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 21:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450Ab0AaCpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 21:45:54 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:40050 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab0AaCpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 21:45:53 -0500
Date: Sun, 31 Jan 2010 02:45:08 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jeff Garrett <jeff@jgarrett.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Myron Stowe <myron.stowe@hp.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works with
	pci=use_crs)
Message-ID: <20100131024508.GA9334@srcf.ucam.org>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <201001271345.54454.bjorn.helgaas@hp.com> <alpine.LFD.2.00.1001271247450.3570@localhost.localdomain> <201001271403.41955.bjorn.helgaas@hp.com> <4B60CD99.7020305@kernel.org> <1264652762.24020.5.camel@dc7800.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264652762.24020.5.camel@dc7800.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 09:26:02PM -0700, Bjorn Helgaas wrote:

> When ACPI is disabled, I think we just have to accept that we lose some
> functionality.  I don't see the need for alternate ways to accomplish
> everything that ACPI does.  It's becoming less and less useful to
> disable ACPI; I think it's only interesting as a debugging tool, and
> even then it's a sledgehammer.

I'd agree with this. The days where it was plausibly practical to boot 
non-ACPI operating systems on hardware are clearly gone, and people who 
are actually disabling ACPI in the field seem to be doing so in order to 
avoid other bugs - and we're failing to fix those bugs as a result.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
