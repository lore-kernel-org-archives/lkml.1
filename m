Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbYCPSpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbYCPSpY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 14:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbYCPSpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 14:45:12 -0400
Received: from brick.kernel.dk ([87.55.233.238]:3511 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbYCPSpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 14:45:11 -0400
Date: Sun, 16 Mar 2008 19:45:07 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, dgc@sgi.com
Subject: Re: [PATCH 1/7] x86-64: introduce fast variant of smp_call_function_single()
Message-ID: <20080316184506.GW17940@kernel.dk>
References: <1205322940-20127-1-git-send-email-jens.axboe@oracle.com> <1205322940-20127-2-git-send-email-jens.axboe@oracle.com> <47DAC21C.1040805@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DAC21C.1040805@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14 2008, Jeremy Fitzhardinge wrote:
> Jens Axboe wrote:
> >rom: Nick Piggin <npiggin@suse.de>
> >  
> 
> Why is this necessary?  How is smp_call_function_single slow?

Because it's completely serialized by the call_lock spinlock.

-- 
Jens Axboe

