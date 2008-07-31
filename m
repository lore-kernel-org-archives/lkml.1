Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbYGaHrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbYGaHrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 03:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbYGaHrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 03:47:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58262 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752498AbYGaHro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 03:47:44 -0400
Message-ID: <48916DAE.3020406@cn.fujitsu.com>
Date: Thu, 31 Jul 2008 15:45:50 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuset: make ntasks to be a monotonic increasing value
References: <48912FDD.8060006@cn.fujitsu.com> <48916557.8070508@cn.fujitsu.com>
In-Reply-To: <48916557.8070508@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Er, I can't. But this attack is existence theoretically indeed.
And IMO a monotonic increasing value is very helpful for this loop.


Li Zefan wrote:
> Lai Jiangshan wrote:
>> ntasks is not a monotonic increasing value,
>> So maybe fudge+1 processes are created when kmalloc and killed
>> when kfree in every loop. And the loop will not end or
>> repetition a long time.
>>
>> This patch prevent this kind of attack.
>>
> 
> Could you demonstrate how to manage to do this so-called attack in
> real-life?
> 
> 
> 
> 


