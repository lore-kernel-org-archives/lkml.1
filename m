Return-Path: <linux-kernel-owner+w=401wt.eu-S1757078AbZLDTnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078AbZLDTnD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 14:43:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755477AbZLDTnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 14:43:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:40506 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbZLDTnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 14:43:00 -0500
Message-ID: <4B196610.7090101@kernel.org>
Date: Sat, 05 Dec 2009 04:42:08 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net
Subject: Re: [PATCH 16/19] workqueue: reimplement workqueue flushing using
 color coded works
References: <1258692407-8985-1-git-send-email-tj@kernel.org>	 <1258692407-8985-17-git-send-email-tj@kernel.org> <1259927181.17907.98.camel@laptop>
In-Reply-To: <1259927181.17907.98.camel@laptop>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/04/2009 08:46 PM, Peter Zijlstra wrote:
> Hmm, a long while back I did a PI aware workqueue implementation, that
> used nested work-lists to implement barriers and flushing.
> 
> This colour thing seems very prone to starvation when you want to extend
> worklets with priority.

Can you elaborate how it would be prone to starvation?  I was assuming
flat-priority while designing and implementing this as that was the
current behavior and never really thought about priority.

Thanks.

-- 
tejun
