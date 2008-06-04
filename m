Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbYFDCSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbYFDCSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 22:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbYFDCSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 22:18:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55811 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbYFDCSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 22:18:23 -0400
Message-ID: <4845FB18.5000002@cn.fujitsu.com>
Date: Wed, 04 Jun 2008 10:16:56 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: miaox@cn.fujitsu.com, linux-kernel@vger.kernel.org, pj@sgi.com,
       menage@google.com
Subject: Re: [PATCH 1/2] cpusets: restructure the function update_cpumask()
 and update_nodemask()
References: <4843AFC9.7000100@cn.fujitsu.com>	<20080603150346.4611b5ab.akpm@linux-foundation.org>	<4845E80F.5000808@cn.fujitsu.com>	<4845F742.2070301@cn.fujitsu.com> <20080603191108.1c35d3c5.akpm@linux-foundation.org>
In-Reply-To: <20080603191108.1c35d3c5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 04 Jun 2008 10:00:34 +0800 Miao Xie <miaox@cn.fujitsu.com> wrote:
> 
>> on 2008-6-4 8:55 Li Zefan wrote:
>>> Andrew Morton wrote:
>>>> On Mon, 02 Jun 2008 16:31:05 +0800
>>>> Miao Xie <miaox@cn.fujitsu.com> wrote:
>>>>
>>>>> extract two functions from update_cpumask() and update_nodemask().They will be
>>>>> used later for updating tasks' cpus_allowed and mems_allowed after CPU/NODE
>>>>> offline/online.
>>>> Unfortunately this patch conflicts with
>>>> http://userweb.kernel.org/~akpm/mmotm/broken-out/cpusets-fix-bug-when-adding-nonexistent-cpu-or-mem.patch
>>>>
>>>> Please check that the patch which I merged still makes sense.  ie: that
>>>> we did not revert the effects of that bugfix.
>>>>
>>> They are fixing 2 different bugs, so they are irrelated, but unfortunately conflict in
>>> the code due to Miao's first patch which does code restructuring.
>>>
>> Right. I will modify my patches.
> 
> I already did that, didn't I?
> 

Oh, I just had a look at that, and yes you did that, but in a wrong way. :(

You reverted the effects of this bugfix:
	cpusets-fix-bug-when-adding-nonexistent-cpu-or-mem.patch


