Return-Path: <linux-kernel-owner+w=401wt.eu-S933828AbXCNFHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933828AbXCNFHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 01:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933829AbXCNFHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 01:07:19 -0400
Received: from holomorphy.com ([66.93.40.71]:59328 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933828AbXCNFHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 01:07:18 -0400
Date: Tue, 13 Mar 2007 22:07:21 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: New thread RDSL, post-2.6.20 kernels and amanda (tar) miss-fires
Message-ID: <20070314050721.GP2986@holomorphy.com>
References: <200703130428.11014.gene.heskett@gmail.com> <200703131436.33509.gene.heskett@gmail.com> <200703132331.56140.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703132331.56140.gene.heskett@gmail.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 11:31:53PM -0400, Gene Heskett wrote:
> Now, can someone suggest a patch I can revert that might fix this?  The 
> total number of patches between 2.6.20 and 2.6.21-rc1 will have me 
> building kernels to bisect this till the middle of June at this rate.

4 billion patches could be bisected in 34 boots. Between 2.6.20 and
2.6.21-rc1 there are only:

$ git rev-list --no-merges v2.6.20..v2.6.21-rc1  |wc -l
3118

patches, requiring 14 boots. In general ceil(log(n)/log(2))+2 boots.

Of course, this is a little optimistic because it assumes no additional
breakage occurring at the various bisection points. In any event,
assuming (pessimistically) 10 minutes per build, this is 280 minutes or
4 hours and 40 minutes of build time. I estimate the process should
complete well before Friday of this week, never mind June.


-- wli
