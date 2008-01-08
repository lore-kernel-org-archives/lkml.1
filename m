Return-Path: <linux-kernel-owner+w=401wt.eu-S1754366AbYAHWdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbYAHWdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbYAHWdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:33:42 -0500
Received: from gir.skynet.ie ([193.1.99.77]:44333 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbYAHWdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:33:41 -0500
Date: Tue, 8 Jan 2008 22:33:40 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Nick Piggin <npiggin@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/3] drm: nopage
In-Reply-To: <20080108223050.GB25832@wotan.suse.de>
Message-ID: <alpine.DEB.0.82.0801082233160.9570@skynet.skynet.ie>
References: <20080108093815.GA14302@wotan.suse.de>
 <alpine.DEB.0.82.0801082224520.9570@skynet.skynet.ie>
 <20080108223050.GB25832@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well they're all gone.. ;)
> 
> There is a nopfn method which I converted in a subsequent patch I sent you.
> Maybe that's what you mean?
> 

Ah thats what it was, we added a nopfn not a nopage..

Thanks,

Dave.

> Thanks,
> Nick
> > 
> > Dave.
> > 
> > > 
> > > Anyway, please apply.
> > > 
> > > --
> > > 
> > > drm: nopage
> > > 
> > > Convert drm from nopage to fault.
> > > Remove redundant vma range checks.
> > > 
> > > Signed-off-by: Nick Piggin <npiggin@suse.de>
> > > Cc: airlied@linux.ie
> > > Cc: linux-kernel@vger.kernel.org
> > > ---
> 
> 
