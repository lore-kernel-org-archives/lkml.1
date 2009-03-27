Return-Path: <linux-kernel-owner+w=401wt.eu-S1763807AbZC0C0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763807AbZC0C0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 22:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759859AbZC0C0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 22:26:45 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:25432 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbZC0C0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 22:26:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=NViVnXk3u6cg+BzX9bJsUX2zC76aC2cPujJhw9DjSmxqsr4JcV7TgWysEqS8U26J/p
         V0kYQ2y3NDFIZS4TnLYlTJU2fIlbaMEP9c+gZhoE50rEgO3pntvQ4kLllfmDxtrYx3Km
         /rMOPutTs9JKybmkbRcS9f7A9Nf6kWiPrJ45E=
Message-ID: <49CC395B.20003@gmail.com>
Date: Fri, 27 Mar 2009 11:26:35 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 03/14] block: implement blk_rq_map_kern_prealloc()
References: <1237910776-10983-1-git-send-email-tj@kernel.org> <1237910776-10983-4-git-send-email-tj@kernel.org> <49CA4B4B.50408@panasas.com> <49CAE425.5050009@kernel.org> <49CB31DB.2040608@gmail.com> <49CB3765.4070406@panasas.com> <49CB387A.3000006@panasas.com> <49CB56AD.3080101@gmail.com> <49CB65CB.1030905@panasas.com> <49CB6FF8.7050701@gmail.com> <49CB94E9.5040808@panasas.com>
In-Reply-To: <49CB94E9.5040808@panasas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Boaz Harrosh wrote:
> Yes sure, I'll be thinking about this some more too. Once your patch
> pile settles we can sort out an additional cleanup that unifies some
> of today's exported functions, just like you did with the blk_end_request.

I'm currently looking at the mapping API.  It's actually the final
obstacle.  It seems scsi_req_map_sg() should really be in blk-map and
doing that would solve most issues we've been talking about, right?
Anyways, I'll take deeper look and see whether I can clean this up.

> Do you have a public tree I can inspect the all lot in one central
> place? That should be the IDE tree you published few days ago
> right? I'll look for it.

I have ~40 more patches on top of those two.  They're mostly ready.
I'll post them soonish (I want to say later today but I said later
today yesterday too :-)

Thanks.

-- 
tejun
