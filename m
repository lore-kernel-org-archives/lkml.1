Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbYAHWbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbYAHWbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:31:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbYAHWaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:30:52 -0500
Received: from mx1.suse.de ([195.135.220.2]:53911 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391AbYAHWaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:30:52 -0500
Date: Tue, 8 Jan 2008 23:30:50 +0100
From: Nick Piggin <npiggin@suse.de>
To: Dave Airlie <airlied@linux.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/3] drm: nopage
Message-ID: <20080108223050.GB25832@wotan.suse.de>
References: <20080108093815.GA14302@wotan.suse.de> <alpine.DEB.0.82.0801082224520.9570@skynet.skynet.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.82.0801082224520.9570@skynet.skynet.ie>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 10:25:15PM +0000, Dave Airlie wrote:
> 
> 
> > Dave, this patch is against 2.6.24-rc6-mm1. You said git-drm had rewritten this area,
> > but the patch didn't have any rejects and seems to run fine here (although I'm not
> > exactly sure how to exercise drm too well).
> 
> Hi Nick,
> 
> there should be a new nopage method added though which you need to 
> convert..

Well they're all gone.. ;)

There is a nopfn method which I converted in a subsequent patch I sent you.
Maybe that's what you mean?

Thanks,
Nick
> 
> Dave.
> 
> > 
> > Anyway, please apply.
> > 
> > --
> > 
> > drm: nopage
> > 
> > Convert drm from nopage to fault.
> > Remove redundant vma range checks.
> > 
> > Signed-off-by: Nick Piggin <npiggin@suse.de>
> > Cc: airlied@linux.ie
> > Cc: linux-kernel@vger.kernel.org
> > ---
