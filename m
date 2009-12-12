Return-Path: <linux-kernel-owner+w=401wt.eu-S1761782AbZLLFzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761782AbZLLFzD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 00:55:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758201AbZLLFzC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 00:55:02 -0500
Received: from 1wt.eu ([62.212.114.60]:52670 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761218AbZLLFzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 00:55:01 -0500
Date: Sat, 12 Dec 2009 06:54:59 +0100
From: Willy Tarreau <w@1wt.eu>
To: Con Kolivas <kernel@kolivas.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: BFS v0.311 CPU scheduler for 2.6.32
Message-ID: <20091212055459.GC32739@1wt.eu>
References: <200912111124.18118.kernel@kolivas.org> <200912120937.42943.kernel@kolivas.org> <200912120155.39197.bzolnier@gmail.com> <200912121300.54803.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912121300.54803.kernel@kolivas.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Con,

On Sat, Dec 12, 2009 at 01:00:54PM +1100, Con Kolivas wrote:
> > If you are not doing your unpaid kernel work for yourself and for people
> > who recognize/use it then upstream maintainers not liking your changes
> > should really be the least of your worries..
> > 
> 
> Wait, this does not make sense. There's a cyclical flaw in this reasoning. If 
> I cared about their acknowledgment, I would make it mainline mergeable and 
> argue a case for it, which I do not want to do. 
> 
> I'm happy to make reasonable changes to the code consistent with what people 
> who use it want, but what exactly is the point of making it mainline mergeable 
> if it will not be merged?

Many people build their own kernels by :
  1) applying a lot of patches on them (stable + features)
  2) using machine-specific configs

You will get far more testers if they can use the same kernel and
just play with their config files than if they have to patch/unpatch
depending on what they need to have.

I personally would love to be able to add BFS into my kernels for
testing purposes, comparison, and possibly to propose enhancements
and fixes. But I don't want to *replace* mainline code.

Also, I like to have the same kernel sources used on my desktop,
notebook, eeepc, and my bootable USB key. It is a lot easier to
upgrade and a lot easier to spot bugs before they strike in sensible
environments.

Regards,
Willy

