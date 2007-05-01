Return-Path: <linux-kernel-owner+w=401wt.eu-S1946509AbXEAFMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946509AbXEAFMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 01:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946592AbXEAFMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 01:12:36 -0400
Received: from holomorphy.com ([66.93.40.71]:38499 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946509AbXEAFMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 01:12:35 -0400
Date: Mon, 30 Apr 2007 22:11:55 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andi Kleen <ak@suse.de>, Mark Lord <lkml@rtr.ca>, ebiederm@xmission.com,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [30/30] x86_64: Add missing !X86_PAE dependincy to the 2G/2G split.
Message-ID: <20070501051155.GS19966@holomorphy.com>
References: <20070501557.815359000@suse.de> <20070501035829.1C93D13CAF@wotan.suse.de> <20070501043735.GR31925@holomorphy.com> <4636C8AF.6080404@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4636C8AF.6080404@cosmosbay.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III a ?crit :
>> There's some sort of insanity going on here. Since when is 0x78000000
>> a 2GB/2GB split? Mark, dare I ask what you were thinking? That should
>> be VMSPLIT_2G_OPT for 2GB laptops analogously to VMSPLIT_3G_OPT, if
>> nothing else, as it's certainly not 2GB/2GB.

On Tue, May 01, 2007 at 06:57:19AM +0200, Eric Dumazet wrote:
> Please could you stop saying others are insane ?
> They are like you and can fail sometime. Apparently when the patch came, 
> nobody (including you) commented.
> It's not that difficult to think about VMALLOC space (I might be wrong 
> about this, but I feel this explains 78000000 vs 80000000)

I'm obviously aware of vmallocspace. Read carefully:

    >> a 2GB/2GB split? Mark, dare I ask what you were thinking? That should
    >> be VMSPLIT_2G_OPT for 2GB laptops analogously to VMSPLIT_3G_OPT, if
    >> nothing else, as it's certainly not 2GB/2GB.

The meaning of "for laptops" is that it's carving out a chunk of
user virtualspace to use for vmallocspace in lieu of carving out a
piece of the 1:1 mapping of physical memory for the same purpose.


-- wli
