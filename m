Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbYLAE3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbYLAE3h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 23:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbYLAE30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 23:29:26 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:57313 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbYLAE3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 23:29:25 -0500
Date: Sun, 30 Nov 2008 23:29:14 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: drivers/x86 (Was: Re: linux-next: Tree for November 28
 (misc/tc1100))
In-reply-to: <20081129093414.GB26691@elte.hu>
X-X-Sender: lenb@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Len Brown <len.brown@intel.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, x86@kernel.org
Message-id: <alpine.LFD.2.00.0811302325050.3314@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20081128213620.2ec593d4.sfr@canb.auug.org.au>
 <4930307C.30106@oracle.com> <20081129083550.3c23af37.sfr@canb.auug.org.au>
 <20081129093414.GB26691@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 29 Nov 2008, Ingo Molnar wrote:

> 
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi Len,
> > 
> > On Fri, 28 Nov 2008 09:55:08 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > >
> > > make[2]: *** No rule to make target `drivers/misc/tc1100-wmi.o', needed by `drivers/misc/built-in.o'.
> > > 
> > > on allmodconfig & allyesconfig for i386.
> > > 
> > > On, moved to drivers/x86/.  Someone needs to clean up drivers/misc/Makefile.
> > 
> > Just wondering where the move to drivers/x86 was discussed, (reviewed 
> > and tested) and why the change is in the acpi tree and not the x86 
> > tree?
> 
> it will all conflict with pending bits in the x86 tree, so i'd prefer if 
> Len did this atomically after 2.6.29-rc1, without it having this 
> long-term breakage effect.

Is linux-next running into a conflict between x86 and the acpi 
tree today?

thanks,
-Len
