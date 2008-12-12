Return-Path: <linux-kernel-owner+w=401wt.eu-S1758560AbYLLNZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbYLLNZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 08:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757382AbYLLNZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 08:25:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:58444 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755601AbYLLNZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 08:25:38 -0500
Message-ID: <49426676.1060606@kernel.org>
Date: Fri, 12 Dec 2008 22:26:14 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET block#for-2.6.29] block: simplify and fix empty barrier
References: <1227846727-24980-1-git-send-email-tj@kernel.org> <4941D93A.2040405@kernel.org> <20081212063423.GF23742@kernel.dk> <49421088.1050304@kernel.org> <20081212113642.GN23742@kernel.dk>
In-Reply-To: <20081212113642.GN23742@kernel.dk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 12 Dec 2008 13:25:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Fri, Dec 12 2008, Tejun Heo wrote:
>> Jens Axboe wrote:
>>> On Fri, Dec 12 2008, Tejun Heo wrote:
>>>> Jens, did you have time to review this?
>>> Sorry yes, I thought I had sent a reply on this already, weird. I
>>> committed it last week, and it's tested fine here.
>> Ah... thanks.  Next patchset brewing then.  :-)
> 
> Excellent. Are you going forward with the explicit peek/dequeue
> interface for elv_next_request()? If not, then I'll put some time into
> that as I think it needs doing soon. But if you are, I'll happily do
> something else instead.

I'm actually working on that.  As you opposed to the original
proposal, I'm changing the approach, so it would be great if we don't
collide on the same area.

Thanks.  :-)

-- 
tejun
