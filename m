Return-Path: <linux-kernel-owner+w=401wt.eu-S1756651AbYCMPAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbYCMPAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 11:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbYCMPAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 11:00:35 -0400
Received: from brick.kernel.dk ([87.55.233.238]:3803 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbYCMPAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 11:00:35 -0400
Date: Thu, 13 Mar 2008 16:00:31 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, dgc@sgi.com
Subject: Re: [PATCH 0/7] IO CPU affinity testing series
Message-ID: <20080313150031.GB17940@kernel.dk>
References: <1205322940-20127-1-git-send-email-jens.axboe@oracle.com> <47D94035.6080301@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D94035.6080301@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13 2008, Alan D. Brunelle wrote:
> 
> Your suggestion worked Jens, will do some benchmarking, and try to
> figure out why on the side...

Good!

> Subject: [PATCH] IA64 boots with direct call of generic init single
> data
> 
> Need to figure out why it needs to be done earlier on ia64.

Sometimes I find that the __init and friends need some include magic to
actually work, even if it compiles and links just fine. If you could
pick at it a bit once the benchmark is out of the way, that would be
great. This is a fine work-around for now.

-- 
Jens Axboe

