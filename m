Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbZKUCyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbZKUCyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 21:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbZKUCyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 21:54:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:46389 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172AbZKUCyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 21:54:35 -0500
Message-ID: <4B075635.7000301@kernel.org>
Date: Sat, 21 Nov 2009 11:53:41 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jeff@garzik.org, mingo@elte.hu, akpm@linux-foundation.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com, avi@redhat.com,
       peterz@infradead.org, johannes@sipsolutions.net
Subject: Re: [PATCH 17/19] workqueue: introduce worker
References: <1258692407-8985-1-git-send-email-tj@kernel.org>	 <1258692407-8985-18-git-send-email-tj@kernel.org> <1258760671.3058.28.camel@palomino.walls.org>
In-Reply-To: <1258760671.3058.28.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

11/21/2009 08:44 AM, Andy Walls wrote:
> Do you have a pressing need to use the naming convention you have chosen
> over the current convention?  I do realize that the "/cpu_numnber" part
> of the current naming convention needs to be augmented.  I just am
> apprehensive about the descriptive names all being replaced with
> "kworker".

There will be no fixed relationship between worker thread and
workqueue, so it simply wouldn't be possible to give a specific name
to worker threads - much like we only have keventd for all the works
queued to the default workqueue for the current implementation.  As
long as stack trace can be extracted, I don't think it will hamper
with debugging too much.

Thanks.

-- 
tejun
