Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbYKVMoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbYKVMoQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 07:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757592AbYKVMn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 07:43:59 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:25480 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757405AbYKVMn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 07:43:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=UCs2nt3P9TwXlerb9OKchgmN5wUuFv7OyC7Ie2WsRaVAEVCu0u+zh3uDNz2HDZb697
         mkcwfUdcaVPwASy69yWw4bwYk/xBY9bXLhV1H+XDSnvGKVtG7+WdhcBAFiy+eM21jMBv
         f7qWwO+aqs3E5XJ01eiQDj5iAAOrSwImdXcYQ=
Message-ID: <4927FE87.6050005@gmail.com>
Date: Sat, 22 Nov 2008 21:43:51 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       arjan@linux.intel.com, torvalds@linux-foundation.org, hch@infradead.org,
       mingo@elte.hu, rminnich@sandia.gov, ericvh@gmail.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH fwd] poll: allow f_op->poll to sleep
References: <E1L3oK1-0001Pz-J9@pomaz-ex.szeredi.hu> <20081122123942.GF5707@parisc-linux.org>
In-Reply-To: <20081122123942.GF5707@parisc-linux.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Sat, Nov 22, 2008 at 09:58:33AM +0100, Miklos Szeredi wrote:
>> +int poll_schedule_timeout(struct poll_wqueues *pwq, int state,
>> +			  ktime_t *expires, unsigned long slack)
> 
> All callers of poll_schedule() and poll_schedule_timeout() pass
> TASK_INTERRUPTIBLE.  We can elide the 'state' argument.

Well, I wanted to keep it as to keep it more consistent with other
schedule() functions but both Miklos and you don't seem to like it, so I
might as well just drop it.  Andrew, what do you think?

Thanks.

-- 
tejun
