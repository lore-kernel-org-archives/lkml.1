Return-Path: <linux-kernel-owner+w=401wt.eu-S1763868AbXJETgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763868AbXJETgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 15:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760419AbXJETgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 15:36:32 -0400
Received: from mail.gmx.net ([213.165.64.20]:48270 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759460AbXJETgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 15:36:32 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19VDvMEtRVVGsocuTq+ltkHKcS8PEJMck3l+QmxmJ
	VfTJBeKPy/HvJn
Date: Fri, 5 Oct 2007 21:36:51 +0200 (CEST)
From: Guennadi Liakhovetski <lg@denx.de>
X-X-Sender: lyakh@poirot.grange
To: Hugh Dickins <hugh@veritas.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: tmpfs disabled in .config but in /proc/filesystems
In-Reply-To: <Pine.LNX.4.64.0710051637380.16909@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.60.0710052134180.10392@poirot.grange>
References: <Pine.LNX.4.60.0710051637200.10392@poirot.grange>
 <Pine.LNX.4.64.0710051637380.16909@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2007, Hugh Dickins wrote:

> On Fri, 5 Oct 2007, Guennadi Liakhovetski wrote:
> > Am I running crazy here (some 2.6.23-rc6-ish)?
> > 
> > $ zcat /proc/config.gz | grep TMPFS
> > # CONFIG_TMPFS is not set
> > $ grep tmpfs /proc/filesystems
> > nodev   tmpfs
> 
> tmpfs (mm/shmem.c) is used by the kernel to support shared memory
> of various kinds even when CONFIG_TMPFS is not set.  But only when
> CONFIG_TMPFS=y can users mount a tmpfs as a fully capable filesystem.
> Confusing, yes: sorry for putting the fear of craziness upon you.

Oops, sorry, now I remember reading about this... As a matter of fact, the 
presence in /proc/filesystem - was it a deliberate decision, or 
technically preferrable or a mistake? Wouldn't it be more logical to 
completely hide it from the user then?

Thanks
Guennadi
---
Guennadi Liakhovetski
