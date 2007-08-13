Return-Path: <linux-kernel-owner+w=401wt.eu-S1030821AbXHMM56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030821AbXHMM56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S942921AbXHMHxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 03:53:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:57093 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S942914AbXHMHw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 03:52:58 -0400
Date: Mon, 13 Aug 2007 09:52:57 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] spinlock: lockbreak cleanup
Message-ID: <20070813075257.GB31736@wotan.suse.de>
References: <20070808042234.GE11018@wotan.suse.de> <200708110207.43977.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708110207.43977.ak@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2007 at 02:07:43AM +0200, Andi Kleen wrote:
> 
> Nick,
> 
> These two patches make my P4 (single socket HT) test box not boot. I dropped them for now.
> 
> Some oopses

Sorry, the trylock had a race where it would not work correctly :(
Have fixed it now and will do more testing and resend to you.

Thanks,
Nick
