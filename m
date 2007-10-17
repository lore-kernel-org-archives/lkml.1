Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbXJQSPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbXJQSPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 14:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757356AbXJQSOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 14:14:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49637 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757083AbXJQSOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 14:14:47 -0400
Date: Wed, 17 Oct 2007 11:14:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] block subsystem related crash with latest -git
In-Reply-To: <20071017180255.GA8375@elte.hu>
Message-ID: <alpine.LFD.0.999.0710171113380.26902@woody.linux-foundation.org>
References: <20071017154655.GA13394@elte.hu>
 <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org>
 <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk>
 <20071017172158.GH15552@kernel.dk> <20071017172932.GI15552@kernel.dk>
 <alpine.LFD.0.999.0710171053180.26902@woody.linux-foundation.org>
 <20071017180255.GA8375@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Oct 2007, Ingo Molnar wrote:
> 
> built and booted your patch (removed Jens's) but it still crashes in 
> blk_rq_map_sg() - see below. Should i have left something from Jens's 
> patch?

The *real* fix in Jens' patch (and the only thing that really matters) is 
the one to drivers/scsi/scsi_lib.c.

The rest is all fluff.

		Linus
