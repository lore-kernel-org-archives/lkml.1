Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbZEQBTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbZEQBTb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 21:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754262AbZEQBTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 21:19:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:4947 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbZEQBTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 21:19:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,206,1241420400"; 
   d="scan'208";a="143631699"
Date: Sun, 17 May 2009 09:19:06 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Rik van Riel <riel@redhat.com>
Cc: Ray Lee <ray-lk@madrabbit.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Satish Eerpini <eerpini@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: unresponsiveness on linux desktop during file copy
Message-ID: <20090517011906.GA6375@localhost>
References: <93655eb70905151007v5f9bb34aj34be4b65ffeb02a4@mail.gmail.com> <2c0942db0905151102y4f144437xa02632effccda72c@mail.gmail.com> <alpine.DEB.1.10.0905151533070.13433@qirst.com> <2c0942db0905160903i5517d3d6l50fc7457a2629694@mail.gmail.com> <4A0EFA08.4060106@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0EFA08.4060106@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 17, 2009 at 01:38:16AM +0800, Rik van Riel wrote:
> Ray Lee wrote:
> > On Fri, May 15, 2009 at 12:33 PM, Christoph Lameter
> > <cl@linux-foundation.org> wrote:
> >> On Fri, 15 May 2009, Ray Lee wrote:
> >>
> >>> Which kernel version? If it's something recent, your programs may be
> >>> getting swapped out due to a flaw in the latest kernels, where it
> >>> accidentally prefers caching file data over mapped pages. If that's
> >>> the case, Rik (cc:d) is working on patches to address the issue, and
> >>> may appreciate another tester.
> >> Please keep me in the loop. I'd be interested if those patches work and
> >> what effect they have.
> > 
> > Whoops, looks like Wu Fengguang (cc:d), not Rik, has been working on
> > those patches. See the messages starting with "[PATCH 0/3] make mapped
> > executable pages the first class citizen" [
> > http://lkml.org/lkml/2009/5/16/23 ]
> 
> We both have.  Wu's patches build on a patch of mine, which
> Andrew has already merged into -mm.
> 
> http://lkml.org/lkml/2009/4/29/489

Yes, better to apply Rik and mine patches together to get the best
cache behavior. Rik's patch is crucial. They are both small patches,
so can be backported trivially. Satish, what's your kernel version
(or, do you want to try a newer kernel)? And the content of
/proc/meminfo?

Thanks,
Fengguang
