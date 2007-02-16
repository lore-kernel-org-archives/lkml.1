Return-Path: <linux-kernel-owner+w=401wt.eu-S1423359AbXBPGps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423359AbXBPGps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 01:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423363AbXBPGps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 01:45:48 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:54326 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423358AbXBPGpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 01:45:47 -0500
Date: Thu, 15 Feb 2007 22:45:45 -0800 (PST)
From: Zwane Mwaikambo <zwane@infradead.org>
Subject: Re: [PATCH] Fix modular AGPGART (ia64 allmodconfig)
In-reply-to: <20070216062308.GD22490@athena.road.mcmartin.ca>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Message-id: <Pine.LNX.4.64.0702152240570.12571@montezuma.fsmlabs.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <Pine.LNX.4.64.0702152151460.12615@montezuma.fsmlabs.com>
 <20070216062308.GD22490@athena.road.mcmartin.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007, Kyle McMartin wrote:

> On Thu, Feb 15, 2007 at 10:09:57PM -0800, Zwane Mwaikambo wrote:
> > +ifeq ($(CONFIG_COMPAT),y)
> > +agpgart-y			+= compat_ioctl.o
> > +endif
> > +
> 
> eh?
> 
> Couldn't this be?
> agpgart-$(CONFIG_COMPAT)	+= compat_ioctl.o

Yep thay works too and does look cleaner
