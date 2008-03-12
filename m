Return-Path: <linux-kernel-owner+w=401wt.eu-S1756343AbYCLXc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbYCLXc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 19:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbYCLXct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 19:32:49 -0400
Received: from mail.gmx.net ([213.165.64.20]:47523 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750795AbYCLXcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 19:32:48 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18h8hRBFc0hNk5sxjYr+phFSdfDRAZgXJ5FeYAqVf
	wtpnDjDN/MxhIt
Date: Thu, 13 Mar 2008 00:32:48 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Greg KH <greg@kroah.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <len.brown@intel.com>
Subject: Re: pcibios_scanned needs to be set in ACPI?  (was Re: 2.6.25-rc5:
 Reported regressions from 2.6.24)
In-Reply-To: <20080312231601.GB24820@kroah.com>
Message-ID: <Pine.LNX.4.64.0803130031190.14097@axis700.grange>
References: <200803110014.52985.rjw@sisk.pl>
 <alpine.LFD.1.00.0803101913340.5896@woody.linux-foundation.org>
 <47D6D61F.4050805@garzik.org> <200803112341.42517.rjw@sisk.pl>
 <alpine.LFD.1.00.0803121300160.3557@woody.linux-foundation.org>
 <20080312203205.GB17187@kroah.com> <20080312212704.GA16836@kroah.com>
 <alpine.LFD.1.00.0803121502450.3557@woody.linux-foundation.org>
 <20080312223431.GA24150@kroah.com> <alpine.LFD.1.00.0803121553070.3557@woody.linux-foundation.org>
 <20080312231601.GB24820@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Greg KH wrote:

> It oopses at shutdown?  I thought this was originally reported as a
> "will not power off" which for a while was attributed to the cpufreq fix
> that went into -rc2 or -rc3.

As I already replied to Linus, no, it doesn't.

> It would be interesting to see if reverting the pci_bus patch did
> anything about the fact that we register the root PCI bus through two
> different methods.

You mean this: http://marc.info/?l=linux-kernel&m=120483340622706&w=2

Thanks
Guennadi
---
Guennadi Liakhovetski
