Return-Path: <linux-kernel-owner+w=401wt.eu-S1760378AbZACWLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760378AbZACWLu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 17:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbZACWLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 17:11:39 -0500
Received: from 8bytes.org ([88.198.83.132]:41717 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbZACWLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 17:11:38 -0500
Date: Sat, 3 Jan 2009 23:11:35 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Joerg Roedel <joerg.roedel@amd.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, gregkh@suse.de,
       avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org,
       weidong.han@intel.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [GIT PULL] various IOMMU updates for 2.6.29
Message-ID: <20090103221135.GA14298@8bytes.org>
References: <20090103173130.GB6103@amd.com> <20090103220611.GA4389@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090103220611.GA4389@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Sat, Jan 03, 2009 at 11:06:11PM +0100, Ingo Molnar wrote:
> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > Hi Linus,
> > 
> > The following changes since commit 6680598b44ed3c0052d155522eb21fc5a00de5f3:
> >   Ingo Molnar (1):
> >         Disallow gcc versions 3.{0,1}
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git for-linus
> 
> hi Joerg, there's a new build failure on 64-bit x86:
> 
>   drivers/built-in.o: In function `alloc_iommu':
>   : undefined reference to `iommu_calculate_agaw'
> 

thanks for the report. I will look at it.

Joerg

