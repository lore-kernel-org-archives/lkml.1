Return-Path: <linux-kernel-owner+w=401wt.eu-S1752881AbXDMIVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbXDMIVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 04:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbXDMIVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 04:21:39 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:59466 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbXDMIVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 04:21:38 -0400
X-Originating-Ip: 74.109.98.130
Date: Fri, 13 Apr 2007 04:20:10 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] Kill off legacy power management stuff.
In-Reply-To: <20070413180942.b7cf0665.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0704130416250.15118@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0704122025380.3628@CPE00045a9c397f-CM001225dbafb6>
 <20070413180942.b7cf0665.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007, Stephen Rothwell wrote:

> On Thu, 12 Apr 2007 20:33:16 -0400 (EDT) "Robert P. J. Day" <rpjday@mindspring.com> wrote:
> >
> > just something i threw together, not in final form, but it
> > represents tossing the legacy PM stuff.  at the moment, the
> > menuconfig entry for PM_LEGACY lists it as "DEPRECATED", while the
> > help screen calls it "obsolete."  that's a good sign that it's
> > getting close to the time for it to go, and the removal is fairly
> > straightforward, but there's no mention of its removal in the
> > feature removal schedule file.
>
> One thing that comes to mind is that you will need some way to make sure
> that only one of ACPI and APM get initialized ...

i don't see how that has anything to do with removing legacy PM
support.  you can select both ACPI and APM *now*.  if that's a bad
thing, then fixing it is a completely independent issue.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
