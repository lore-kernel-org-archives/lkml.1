Return-Path: <linux-kernel-owner+w=401wt.eu-S1761314AbZBLWTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761314AbZBLWTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 17:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758202AbZBLWTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 17:19:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37995
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756713AbZBLWTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 17:19:11 -0500
Date: Thu, 12 Feb 2009 14:19:05 -0800 (PST)
Message-Id: <20090212.141905.48656767.davem@davemloft.net>
To: airlied@gmail.com
Cc: airlied@linux.ie, benh@kernel.crashing.org,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5]: ATI/RADEON DRM bug fixes...
From: David Miller <davem@davemloft.net>
In-Reply-To: <21d7e9970902120326j2ce300d9x7df5a870c69a95f5@mail.gmail.com>
References: <20090212.021522.217840575.davem@davemloft.net>
	<21d7e9970902120326j2ce300d9x7df5a870c69a95f5@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@gmail.com>
Date: Thu, 12 Feb 2009 21:26:51 +1000

> On Thu, Feb 12, 2009 at 8:15 PM, David Miller <davem@davemloft.net> wrote:
> >
> > David, this work is against your drm-next branch.
> >
> > Here are a collection of bug fixes for the Radeon DRM support.  Most
> > of them have to do with trying to access kernel virtual addresses
> > using DRM_READ32() and DRM_WRITE32().
> >
> > With these patches at least the writeback test works on sparc64 and
> > the CP is able to process commands in the ring.  I'm now diagnosing
> > some further problem that's preventing Xorg from functioning fully but
> > I should be able to diagnose that soon.
> >
> > You'll probably love patch #4 in this series, and it probably explains
> > all kinds of weird problems people run into with DRM on radeon cards.
> 
> Thanks Dave,
> 
> These all look great, the EMITED one has potential to regress
> something by fixing it,
> but I think it might actually make things better, I'll push all of
> these to Linus asap as
> they all fix real bugs. I've put them into my drm-fixes branch and I'll try and
> re-review and get some testing tomorrow when I'm more awake.

Note that these depend upon Ben's drm_addmap and resource fixed in
your drm-next branch, sparc64 was also broken by those problems.
