Return-Path: <linux-kernel-owner+w=401wt.eu-S1754165AbXFOI7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbXFOI7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 04:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbXFOI73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 04:59:29 -0400
Received: from gate.crashing.org ([63.228.1.57]:52453 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457AbXFOI73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 04:59:29 -0400
Subject: Re: drm: fix radeon setparam on 32/64 bit systems.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>
In-Reply-To: <1181897060.25228.323.camel@pmac.infradead.org>
References: <200706150159.l5F1xNgM000459@hera.kernel.org>
	 <1181897060.25228.323.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Fri, 15 Jun 2007 18:58:25 +1000
Message-Id: <1181897905.26853.66.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-15 at 09:44 +0100, David Woodhouse wrote:
> On Fri, 2007-06-15 at 01:59 +0000, Linux Kernel Mailing List wrote:
> > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9b01bd5b284bbf519b726b39f1352023cb5e9e69
> > Commit:     9b01bd5b284bbf519b726b39f1352023cb5e9e69
> > Parent:     dc7a93190c21edbf3ed23e678ad04f852b9cff28
> > Author:     Dave Airlie <airlied@linux.ie>
> > AuthorDate: Sun Jun 10 16:00:27 2007 +1000
> > Committer:  Dave Airlie <airlied@linux.ie>
> > CommitDate: Sun Jun 10 16:00:27 2007 +1000
> > 
> >     drm: fix radeon setparam on 32/64 bit systems.
> >     
> >     The alignment on 64-bit is different for 64-bit values.
> 
> Only on i386. I think you just broke ppc32-on-ppc64.

Indeed... I'm pretty sure the 64 bits quantity will be naturally aligned
on ppc32 (and possibly others).

Ben.


