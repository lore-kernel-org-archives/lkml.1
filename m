Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab0BBUza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 15:55:30 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:7497 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab0BBUz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 15:55:27 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works with pci=use_crs)
Date: Tue, 2 Feb 2010 13:55:24 -0700
User-Agent: KMail/1.9.10
Cc: Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jeff Garrett <jeff@jgarrett.org>, Linux PCI <linux-pci@vger.kernel.org>
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera> <4B666960.8000304@kernel.org> <201002022142.58762.rjw@sisk.pl>
In-Reply-To: <201002022142.58762.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002021355.25248.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 February 2010 01:42:58 pm Rafael J. Wysocki wrote:
> On Monday 01 February 2010, Yinghai Lu wrote:
> > On 01/31/2010 04:22 PM, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.32.  Please verify if it still should be listed and let me know
> > > (either way).
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15124
> > > Subject		: PCI host bridge windows ignored (works with pci=use_crs)
> > > Submitter	: Jeff Garrett <jeff@jgarrett.org>
> > > Date		: 2010-01-13 5:37 (19 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=126336296600307&w=4
> > > Handled-By	: Yinghai Lu <yinghai@kernel.org>
> > > 		  Bjorn Helgaas <bjorn.helgaas@hp.com>
> > > 
> > 
> > should be closed.
> 
> Is there a fix in the Linus' tree?

Yes.  The regression was caused by the addition of arch/x86/pci/intel_bus.c.

Jeff's patch: http://lkml.org/lkml/2010/1/27/449 is in Linus' tree as
commit e8e06eae4ffd68, and Jeff confirmed that it works for him.

Bjorn
