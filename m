Return-Path: <linux-kernel-owner+w=401wt.eu-S1759147AbYDZQPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147AbYDZQPZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 12:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbYDZQPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 12:15:14 -0400
Received: from mtl.rackplans.net ([69.90.0.18]:39659 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150AbYDZQPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 12:15:13 -0400
Date: Sat, 26 Apr 2008 12:15:11 -0400 (EDT)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: Jiri Kosina <jkosina@suse.cz>
cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.25] compat VDSO option not disabling
In-Reply-To: <Pine.LNX.4.64.0804251632490.19002@twin.jikos.cz>
Message-ID: <alpine.DEB.1.10.0804261213200.28624@mtl.rackplans.net>
References: <alpine.DEB.1.10.0804241244360.28216@mtl.rackplans.net> <Pine.LNX.4.64.0804251632490.19002@twin.jikos.cz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I havn't enabled compat VDSO at the kernel command line or otherwise.  
Something broke with this option. 

	Gerhard


On Fri, 25 Apr 2008, Jiri Kosina wrote:

> Date: Fri, 25 Apr 2008 16:33:48 +0200 (CEST)
> From: Jiri Kosina <jkosina@suse.cz>
> To: Gerhard Mack <gmack@innerfire.net>
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: [2.6.25] compat VDSO option not disabling
> 
> On Thu, 24 Apr 2008, Gerhard Mack wrote:
> 
> > On my laptop I disabled the compat vdso option but it is till being 
> > mapped.. Any ideas?
> 
> The changelog of the commit below explains that.
> 
> commit 1dbf527c51c6c20c19869c8125cb5b87c3d09506
> Author: Jeremy Fitzhardinge <jeremy@goop.org>
> Date:   Wed May 2 19:27:12 2007 +0200
> 
>     [PATCH] i386: Make COMPAT_VDSO runtime selectable.
> 
>     Now that relocation of the VDSO for COMPAT_VDSO users is done at
>     runtime rather than compile time, it is possible to enable/disable
>     compat mode at runtime.
> 
>     This patch allows you to enable COMPAT_VDSO mode with "vdso=2" on the
>     kernel command line, or via sysctl.  (Switching on a running system
>     shouldn't be done lightly; any process which was relying on the compat
>     VDSO will be upset if it goes away.)
> 
>     The COMPAT_VDSO config option still exists, but if enabled it just
>     makes vdso_enabled default to VDSO_COMPAT.
> 
> 

--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
