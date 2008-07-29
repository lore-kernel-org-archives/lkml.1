Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbYG2BcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbYG2BcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 21:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbYG2BcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 21:32:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56192 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbYG2BcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 21:32:12 -0400
Message-ID: <488E72BE.9070108@cn.fujitsu.com>
Date: Tue, 29 Jul 2008 09:30:38 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: akpm@linux-foundation.org, menage@google.com,
       seto.hidetoshi@jp.fujitsu.com, laijs@cn.fujitsu.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] cpuset: clean up cpuset hierarchy traversal code
References: <488D332A.1030008@cn.fujitsu.com> <20080728010141.fbd33866.pj@sgi.com>
In-Reply-To: <20080728010141.fbd33866.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Li Zefan wrote:
>> -	q = kfifo_alloc(number_of_cpusets * sizeof(cp), GFP_KERNEL, NULL);
> 
> 
> The block comment for rebuild_sched_domains() states:
> 
>> ... May take callback_mutex during
>> * call due to the kfifo_alloc() and kmalloc() calls.
> 
> I suspect that mention of kfifo_alloc() is no longer correct,
> with your patch.  If so, perhaps you could send a little additional
> fix patch, to remove that mention from the comment.
> 

Yes, but I just noticed Max removes that comment completely in his patch,
so I guess I can leave it as it is.

