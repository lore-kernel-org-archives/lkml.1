Return-Path: <linux-kernel-owner+w=401wt.eu-S1765349AbXHAP60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765349AbXHAP60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763792AbXHAP6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:58:01 -0400
Received: from qb-out-0506.google.com ([72.14.204.236]:40041 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763025AbXHAP6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:58:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=dRI1y4HozIHuNuH8wStzYhbc2VVr/b/RAnB5saL1yulr2tV+w46yY/cCbUkA8dF0Lq6+0auyZN4u4znusppmqNvm5//VGYYomNJiLJlLYpIjb0gAXIKA8qhx1uWDZ27OBxOigvra07tnKlzSIiChJpXqnQeYxkRaYdFz9DEolPw=
Date: Thu, 2 Aug 2007 00:57:53 +0900
From: Tejun Heo <htejun@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 013 of 35] Don't update bi_hw_*_size if we aren't going to merge.
Message-ID: <20070801155753.GF13674@htj.dyndns.org>
References: <20070731112539.22428.patches@notabene> <1070731021655.25270@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1070731021655.25270@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 12:16:55PM +1000, NeilBrown wrote:
> 
> ll_merge_requests_fn can update bi_hw_*_size in one case where we end
> up not merging.  This is wrong.
> 
> Signed-off-by: Neil Brown <neilb@suse.de>

As this is a bug fix, I think it would better to bump this to the top
of the series such that it can be pushed into mainline.

Thanks.

-- 
tejun
