Return-Path: <linux-kernel-owner+w=401wt.eu-S1758960AbZASJp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758960AbZASJp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 04:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757319AbZASJpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 04:45:12 -0500
Received: from smtp.nokia.com ([192.100.122.233]:62277 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757149AbZASJpL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 04:45:11 -0500
Date: Mon, 19 Jan 2009 11:44:07 +0200 (EET)
Message-Id: <20090119.114407.177399457.Hiroshi.DOYU@nokia.com>
To: dbrownell@users.sourceforge.net, david-b@pacbell.net
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/6] omap iommu: tlb and pagetable primitives
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
In-Reply-To: <200901171248.45757.david-b@pacbell.net>
References: <20090116083709.18344.74524.stgit@oreo.research.nokia.com>
	<20090117160608.GA12341@n2100.arm.linux.org.uk>
	<200901171248.45757.david-b@pacbell.net>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 19 Jan 2009 09:44:09.0719 (UTC) FILETIME=[7A597070:01C97A1A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

From: "ext David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH 1/6] omap iommu: tlb and pagetable primitives
Date: Sat, 17 Jan 2009 12:48:45 -0800

> On Saturday 17 January 2009, Russell King - ARM Linux wrote:
> > > +#ifdef DEBUG_VERBOSE
> > > +             dev_dbg(obj->dev, "%s:\ta new pte:%p\n", __func__, iopte);
> > > +#endif
> > 
> > Not sure wrapping these in DEBUG_VERBOSE is necessary.  dev_dbg() is a
> > no-op unless DEBUG is defined.
> 
> Use dev_vdbg() to get the "NOP unless VERBOSE is set" semantics.

Thanks. This is what I wanted... I'll update with "dev_vdbg()".
