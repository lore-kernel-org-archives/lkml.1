Return-Path: <linux-kernel-owner+w=401wt.eu-S964930AbXCUU1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964930AbXCUU1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 16:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964896AbXCUU1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 16:27:42 -0400
Received: from smtp.cce.hp.com ([161.114.21.22]:6059 "EHLO
	ccerelrim01.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964893AbXCUU1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 16:27:41 -0400
X-Greylist: delayed 1864 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Mar 2007 16:27:41 EDT
From: "Bob Picco" <bob.picco@hp.com>
Date: Wed, 21 Mar 2007 15:55:37 -0500
To: Andy Whitcroft <apw@shadowen.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Bob Picco <bob.picco@hp.com>,
       Dave Hansen <hansendc@us.ibm.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] pfn_valid_within() HOLES_WITHIN_ZONES helper
Message-ID: <20070321205537.GN10084@localhost>
References: <Pine.LNX.4.64.0703211510340.15309@skynet.skynet.ie> <exportbomb.1174504472@pinky>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <exportbomb.1174504472@pinky>
User-Agent: Mutt/1.5.11
X-PMX-Version: 5.2.1.279297, Antispam-Engine: 2.4.0.264935, Antispam-Data: 2007.3.21.124434
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Wihitcroft wrote:	[Wed Mar 21 2007, 02:14:55PM EST]
> The thought of having a helper for the holes within zones code
> has come up on two different threads in the last couple of days.
> So I took the pfn_valid_within() patch I had developed for the
> linear reclaim series and pulled it forward to 2.6.21-rc4-mm1.
> I have split it into a three patch series to better align with the
> affected patch sets within -mm.
> 
> add-pfn_valid_within-helper-for-sub-MAX_ORDER-hole-detection --
>   adds the base helper and utilises it within the buddy allocator,
> 
> anti-fragmentation-switch-over-to-pfn_valid_within() -- changes
>   references within Mel Gormans anti-fragmentation patch series, and
> 
> lumpy-move-to-using-pfn_valid_within() -- changes references with
>   my lumpy reclaim patch series.
> 
> -apw
Andy,

Thanks for doing this.

Acked-by: Bob Picco <bob.picco@hp.com>

