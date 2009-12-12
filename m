Return-Path: <linux-kernel-owner+w=401wt.eu-S1753760AbZLLGPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbZLLGPR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 01:15:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbZLLGPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 01:15:16 -0500
Received: from 1wt.eu ([62.212.114.60]:52674 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbZLLGPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 01:15:15 -0500
Date: Sat, 12 Dec 2009 07:14:47 +0100
From: Willy Tarreau <w@1wt.eu>
To: Con Kolivas <kernel@kolivas.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: BFS v0.311 CPU scheduler for 2.6.32
Message-ID: <20091212061447.GB2856@1wt.eu>
References: <200912111124.18118.kernel@kolivas.org> <200912121300.54803.kernel@kolivas.org> <20091212055459.GC32739@1wt.eu> <200912121710.44216.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912121710.44216.kernel@kolivas.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 12, 2009 at 05:10:44PM +1100, Con Kolivas wrote:
> > Also, I like to have the same kernel sources used on my desktop,
> > notebook, eeepc, and my bootable USB key. It is a lot easier to
> > upgrade and a lot easier to spot bugs before they strike in sensible
> > environments.
> 
> Thanks Willy. 
> 
> That's the first meaningful reason I've heard for it. I may have to consider 
> it now. It still would be compile time limited so probably not quite what 
> you're hoping for. I don't have the time and energy to do and maintain the 
> whole plugsched crap for boottime selection all over again, and that adds 
> overhead which goes against one of my prime objectives.

No problem, as I said, I want to use the same *sources*, not to be able
to hot-swap the scheduler. But basically I have a directory named "configs"
in which all of my machines configs are stored. I run "build-kernel-list"
over those configs from the kernel dir and I get all of my new kernels.
You can now easily understand why I don't want to patch in the middle of
the process :-)

Thanks,
Willy

