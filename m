Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbZDNLSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbZDNLSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 07:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbZDNLSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 07:18:40 -0400
Received: from brick.kernel.dk ([93.163.65.50]:58848 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbZDNLSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 07:18:39 -0400
Date: Tue, 14 Apr 2009 13:18:38 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nikanth Karthikesan <knikanth@novell.com>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Kleikamp <shaggy@austin.ibm.com>, xfs-masters@oss.sgi.com
Subject: Re: [PATCH 0/6] Handle bio_alloc failure
Message-ID: <20090414111838.GG5178@kernel.dk>
References: <200904141636.26557.knikanth@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904141636.26557.knikanth@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14 2009, Nikanth Karthikesan wrote:
> Hi Jens
> 
> Some of the callers of bio_alloc() assume that it will never fail and always 
> return bios. But it can fail. This patch set changes those callers to take 
> action when bio_alloc() fails.

It will not fail as long as __GFP_WAIT is set, which it is for all 6 of
your patches.

-- 
Jens Axboe

