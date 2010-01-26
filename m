Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808Ab0AZSXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab0AZSXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 13:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791Ab0AZSXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 13:23:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754785Ab0AZSXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 13:23:20 -0500
Date: Tue, 26 Jan 2010 10:21:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Jeff Garrett <jeff@jgarrett.org>,
       Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Myron Stowe <myron.stowe@hp.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works with
 pci=use_crs)
In-Reply-To: <201001261902.13911.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.1001261016380.3574@localhost.localdomain>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <201001261348.59508.rjw@sisk.pl> <201001261032.37053.bjorn.helgaas@hp.com> <201001261902.13911.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 26 Jan 2010, Rafael J. Wysocki wrote:
> 
> Perhaps it would be sufficient to make pci=use_crs the default and leave the
> option to use intel_bus.c for whoever needs that?

Well, 'use_crs' broke other machines. See:

	http://lkml.org/lkml/2009/6/23/715

but maybe that is all fixed..

		Linus
