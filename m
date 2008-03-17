Return-Path: <linux-kernel-owner+w=401wt.eu-S1755804AbYCQHZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbYCQHZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 03:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbYCQHZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 03:25:18 -0400
Received: from brick.kernel.dk ([87.55.233.238]:8024 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbYCQHZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 03:25:17 -0400
Date: Mon, 17 Mar 2008 08:25:14 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, dgc@sgi.com
Subject: Re: [PATCH 1/7] x86-64: introduce fast variant of smp_call_function_single()
Message-ID: <20080317072514.GY17940@kernel.dk>
References: <1205322940-20127-1-git-send-email-jens.axboe@oracle.com> <1205322940-20127-2-git-send-email-jens.axboe@oracle.com> <47DAC21C.1040805@goop.org> <20080316184506.GW17940@kernel.dk> <47DDA624.8000307@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DDA624.8000307@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 16 2008, Jeremy Fitzhardinge wrote:
> Jens Axboe wrote:
> >On Fri, Mar 14 2008, Jeremy Fitzhardinge wrote:
> >  
> >>Jens Axboe wrote:
> >>    
> >>>rom: Nick Piggin <npiggin@suse.de>
> >>> 
> >>>      
> >>Why is this necessary?  How is smp_call_function_single slow?
> >>    
> >
> >Because it's completely serialized by the call_lock spinlock.
> >  
> 
> Hm, yes.  Would it be possible to implement smp_call_function_mask in a 
> generic way to avoid that?  Turn the static structure into a per-cpu 
> request list?

Have you looked at the patches you are replying to? :-)

-- 
Jens Axboe

