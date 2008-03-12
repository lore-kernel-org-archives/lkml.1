Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbYCLRy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbYCLRy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 13:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYCLRyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 13:54:50 -0400
Received: from brick.kernel.dk ([87.55.233.238]:12570 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbYCLRyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 13:54:49 -0400
Date: Wed, 12 Mar 2008 18:54:45 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, dgc@sgi.com
Subject: Re: [PATCH 0/7] IO CPU affinity testing series
Message-ID: <20080312175443.GV17940@kernel.dk>
References: <1205322940-20127-1-git-send-email-jens.axboe@oracle.com> <47D807BA.7020102@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D807BA.7020102@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12 2008, Alan D. Brunelle wrote:
> 
> Subject: [PATCH] Fixed race: using potentially invalid pointer
> 
> When data->flags & CSD_FLAG_ALLOC is true, the data could be freed by the other processor before we check for CSD_FLAG_WAIT.

Oops, that was pretty dumb. Thanks!

> Also: removed old comment, doesn't quite fit anymore.
> 
> This is applied against Jens' git tree w/ the ia64 additional commit.

Thanks, I'll split this into 3 parts and apply them.

-- 
Jens Axboe

