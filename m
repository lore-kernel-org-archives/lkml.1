Return-Path: <linux-kernel-owner+w=401wt.eu-S1759037AbYDVSnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759037AbYDVSnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 14:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763641AbYDVSnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 14:43:19 -0400
Received: from brick.kernel.dk ([87.55.233.238]:11815 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763655AbYDVSnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 14:43:18 -0400
Date: Tue, 22 Apr 2008 20:43:10 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH 6/11] arm: convert to generic helpers for IPI function  calls
Message-ID: <20080422184310.GR12774@kernel.dk>
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com> <1208851058-8500-7-git-send-email-jens.axboe@oracle.com> <1208876447.31997.30.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208876447.31997.30.camel@pc1117.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22 2008, Catalin Marinas wrote:
> On Tue, 2008-04-22 at 09:57 +0200, Jens Axboe wrote:
> > This converts arm to use the new helpers for smp_call_function() and
> > friends, and adds support for smp_call_function_single(). Not tested
> > at all, not even compiled.
> 
> With the minor fixes below, it compiles and seems to run OK on RealView
> EB + ARM11MPCore (4 CPUs):

Pretty silly errors, missing the cross compiler... Thanks a lot for
checking and testing, I've added your changes!

-- 
Jens Axboe

