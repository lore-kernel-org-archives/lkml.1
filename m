Return-Path: <linux-kernel-owner+w=401wt.eu-S1760155AbYFEUV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760155AbYFEUV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 16:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbYFEUVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 16:21:20 -0400
Received: from mail.queued.net ([207.210.101.209]:4539 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbYFEUVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 16:21:19 -0400
Date: Thu, 5 Jun 2008 16:27:24 -0400
From: Andres Salomon <dilinger@queued.net>
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
       rmh@aybabtu.com
Subject: Re: [PATCH] OLPC: pci: fix up PCI stuff so that PCI_GOANY supports
 OLPC
Message-ID: <20080605162724.51b9cb7f@ephemeral>
In-Reply-To: <Pine.LNX.4.64.0806051307040.30305@shark.he.net>
References: <20080605152914.6f4ca839@ephemeral>
	<Pine.LNX.4.64.0806051307040.30305@shark.he.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2008 13:07:35 -0700 (PDT)
"Randy.Dunlap" <rdunlap@xenotime.net> wrote:

> On Thu, 5 Jun 2008, Andres Salomon wrote:
> 
> > Previously, one would have to specifically choose CONFIG_OLPC and
> > CONFIG_PCI_GOOLPC in order to enable PCI_OLPC.  That doesn't really
> > work for distro kernels, so this patch allows one to choose
> > CONFIG_OLPC and CONFIG_PCI_GOANY in order to build in OLPC support
> > in a generic kernel (as requested by Robert Millan).
> > 
> > This also moves GOOLPC before GOANY in the menuconfig list.
> 
> Please say why... (for above)
> 

The options above GOANY are included in GOANY.
Previously, GOANY did not support GOOLPC, so GOOLPC was listed after it.
Now that GOANY supports GOOLPC, it can be listed above w/ the others.

Plus, _I_ think it looks nicer.  :)  That hunk can easily be removed from
the patch if others disagree.
