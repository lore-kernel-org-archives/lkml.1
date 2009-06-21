Return-Path: <linux-kernel-owner+w=401wt.eu-S1751981AbZFUFQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbZFUFQz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 01:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbZFUFQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 01:16:47 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40120 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbZFUFQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 01:16:47 -0400
Date: Sun, 21 Jun 2009 06:16:47 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Andy Lutomirski <luto@mit.edu>
cc: torvalds@linux-foundation.org, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm: previous pull req + 1.
In-Reply-To: <4A3DABE1.50309@mit.edu>
Message-ID: <alpine.DEB.2.00.0906210615450.6234@skynet.skynet.ie>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie> <4A3DABE1.50309@mit.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I tried this tree (specifically, a merge of Linus' fb20871 this tree) on
> Fedora 11 with modesetting enabled on an integrated Radeon 2100, and plymouthd
> crashes immediately with a corrupt page table.  Photo attached.  After the
> crash, bootup stops, although ctrl-alt-del works.

You need a different userspace, -ati from koji in F11 should do it.

However we have some outstanding rs690 issues that I'm trying to track 
down as we speak,

Dave.

> 
> This is on a Gigabyte GA-MA74GM-S2 (RS690 chipset) with a somewhat old BIOS
> which has never had reliable graphics on X with any kernel and userspace I've
> tried, modesetting or otherwise, so this isn't a regression per se.  But on
> F11's kernel, I can at least boot to a console with modesetting enabled and
> nothing dies until I try to start X, and, with modesetting off on older
> kernels I can boot just fine (again, until I try to use X, at which point
> things break).
> 
> I'd be happy to test things to help debug.
> 
> Thanks,
> Andy
> 
