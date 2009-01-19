Return-Path: <linux-kernel-owner+w=401wt.eu-S1759728AbZASV7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759728AbZASV7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 16:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbZASV7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 16:59:23 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42556 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbZASV7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 16:59:22 -0500
Date: Mon, 19 Jan 2009 21:58:58 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Cc: dbrownell@users.sourceforge.net, david-b@pacbell.net,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/6] omap iommu: tlb and pagetable primitives
Message-ID: <20090119215858.GA31848@n2100.arm.linux.org.uk>
References: <20090116083709.18344.74524.stgit@oreo.research.nokia.com> <20090117160608.GA12341@n2100.arm.linux.org.uk> <200901171248.45757.david-b@pacbell.net> <20090119.114407.177399457.Hiroshi.DOYU@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090119.114407.177399457.Hiroshi.DOYU@nokia.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 11:44:07AM +0200, Hiroshi DOYU wrote:
> Hi David,
> 
> From: "ext David Brownell" <david-b@pacbell.net>
> Subject: Re: [PATCH 1/6] omap iommu: tlb and pagetable primitives
> Date: Sat, 17 Jan 2009 12:48:45 -0800
> 
> > On Saturday 17 January 2009, Russell King - ARM Linux wrote:
> > > > +#ifdef DEBUG_VERBOSE
> > > > +             dev_dbg(obj->dev, "%s:\ta new pte:%p\n", __func__, iopte);
> > > > +#endif
> > > 
> > > Not sure wrapping these in DEBUG_VERBOSE is necessary.  dev_dbg() is a
> > > no-op unless DEBUG is defined.
> > 
> > Use dev_vdbg() to get the "NOP unless VERBOSE is set" semantics.
> 
> Thanks. This is what I wanted... I'll update with "dev_vdbg()".

Sorry, drop the 'v' in that (typo).
