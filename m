Return-Path: <linux-kernel-owner+w=401wt.eu-S1764070AbZLQHlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764070AbZLQHlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 02:41:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764057AbZLQHk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 02:40:57 -0500
Received: from mail.gmx.net ([213.165.64.20]:57197 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1764047AbZLQHky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 02:40:54 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1939Oc4fhh3rNvtns4yFCIfHFah5NT01TqnoyvCNc
	Dsktsga/sZg4pD
Date: Thu, 17 Dec 2009 08:40:57 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       Dan Williams <dan.j.williams@intel.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] sh: fix DMA driver's descriptor chaining and 
 cookie assignment
In-Reply-To: <29ab51dc0912161909r7a6e5397sc751a49a636d755d@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0912170831430.5991@axis700.grange>
References: <Pine.LNX.4.64.0912101826010.4487@axis700.grange> 
 <Pine.LNX.4.64.0912101833170.4487@axis700.grange> <20091211080254.GB7625@linux-sh.org>
  <29ab51dc0912111815s2095539cjc3d0450435725452@mail.gmail.com>
 <29ab51dc0912161909r7a6e5397sc751a49a636d755d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Iwamatsu-san

On Thu, 17 Dec 2009, Nobuhiro Iwamatsu wrote:

> Hi,
> 
> 2009/12/12 Nobuhiro Iwamatsu <iwamatsu@nigauri.org>:
> > Hi,
> >
> > Oh, I was going to check an old patch.
> >
> > 2009/12/11 Paul Mundt <lethal@linux-sh.org>:
> >> On Thu, Dec 10, 2009 at 06:35:11PM +0100, Guennadi Liakhovetski wrote:
> >>> The SH DMA driver wrongly assigns negative cookies to transfer descriptors,
> >>> also, its chaining of partial descriptors is broken. The latter problem is
> >>> usually invisible, because maximum transfer size per chunk is 16M, but if you
> >>> artificially set this limit lower, the driver fails. Since cookies are also
> >>> used in chunk management, both these problems are fixed in one patch. As side
> >>> effects a possible memory leak, when descriptors are prepared, but not
> >>> submitted, and multiple races have also been fixed.
> >>>
> >>> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> >>
> >> Looks good to me.
> > Me too.
> >
> > But I want to check other CPU of sh. I will do next week.
> > Please wait "Acked-by".
> >
> >
> 
> I tested this patch. But I can not apply to Paul's git/HEAD.
> I re-create patch and I attached.
> This version of patch work fine.
> Guennadi, could you test this patch on sh7724?

Thanks for testing. I looked at your version of my patch, and I don't 
agree with it. You needlessly changed indentation in it and also forgot to 
include a "From: " line in it to indicate its original authorship. 
Besides, I think, Dan will be applying this patch on top of current next 
or Linus' tree. Of course, it can be, that my version of the patch does 
not apply to those trees either now. So, Dan, if you cannot merge my 
version of this patch yourself, please, let me know, I'll rebase it, but 
please do not use this version.

Thanks
Guennadi
---
Guennadi Liakhovetski
