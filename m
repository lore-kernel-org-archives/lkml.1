Return-Path: <linux-kernel-owner+w=401wt.eu-S1762731AbYBZJ1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762731AbYBZJ1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 04:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761104AbYBZJ1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 04:27:32 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:53930 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761004AbYBZJ1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 04:27:31 -0500
Date: Tue, 26 Feb 2008 04:27:25 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Adrian Bunk <bunk@kernel.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: is "pci_find_subsys" safe to remove?
In-Reply-To: <20080226091935.GB3498@cs181133002.pp.htv.fi>
Message-ID: <alpine.LFD.1.00.0802260427030.27140@localhost.localdomain>
References: <alpine.LFD.1.00.0802251713050.24343@localhost.localdomain> <20080226091935.GB3498@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008, Adrian Bunk wrote:

> On Mon, Feb 25, 2008 at 05:15:25PM -0500, Robert P. J. Day wrote:
> >
> >   it's not just that it falls under the category of PCI "legacy" but,
> > if you look in drivers/pci/search.c near the bottom:
> >
> > ...
> > #ifdef CONFIG_PCI_LEGACY
> > EXPORT_SYMBOL(pci_find_device);
> > EXPORT_SYMBOL(pci_find_slot);
> > #endif /* CONFIG_PCI_LEGACY */
> > ...
> >
> > that symbol is not being exported even *if* you select PCI_LEGACY.
> > i'm guessing that's an oversight but it would certainly suggest that
> > no one can possibly be using it, no?
>
> It's used by pci_find_device().

yes, i noticed that shortly after hitting the ENTER key.  sigh.  it
was a long day ...

rday
--


========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
