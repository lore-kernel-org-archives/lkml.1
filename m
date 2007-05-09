Return-Path: <linux-kernel-owner+w=401wt.eu-S1756530AbXEIMUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbXEIMUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757150AbXEIMUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:20:05 -0400
Received: from mx1.suse.de ([195.135.220.2]:36664 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754710AbXEIMUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:20:03 -0400
Date: Wed, 9 May 2007 14:20:01 +0200
From: Nick Piggin <npiggin@suse.de>
To: Nikita Danilov <nikita@clusterfs.com>
Cc: linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] lock bitops
Message-ID: <20070509122001.GB24026@wotan.suse.de>
References: <20070508113709.GA19294@wotan.suse.de> <17985.47561.298978.466437@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17985.47561.298978.466437@gargle.gargle.HOWL>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 04:08:41PM +0400, Nikita Danilov wrote:
> Nick Piggin writes:
>  > Hi,
> 
> [...]
> 
>  >  
>  >  /**
>  > + * clear_bit_unlock - Clears a bit in memory with release
>  > + * @nr: Bit to clear
>  > + * @addr: Address to start counting from
>  > + *
>  > + * clear_bit() is atomic and may not be reordered.  It does
> 
> s/clear_bit/clear_bit_unlock/ ?

Yes :)
