Return-Path: <linux-kernel-owner+w=401wt.eu-S1761428AbXEUPHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761428AbXEUPHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 11:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbXEUPHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 11:07:08 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:31958 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbXEUPHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 11:07:07 -0400
Message-ID: <4651B4BF.9040608@sw.ru>
Date: Mon, 21 May 2007 19:03:27 +0400
From: Kirill Korotaev <dev@sw.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: balbir@linux.vnet.ibm.com, Pavel Emelianov <xemul@sw.ru>,
       Paul Menage <menage@google.com>, devel@openvz.org,
       Linux Containers <containers@lists.osdl.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: RSS controller v2 Test results (lmbench )
References: <464C95D4.7070806@linux.vnet.ibm.com> <20070517112357.7adc4763.akpm@linux-foundation.org>
In-Reply-To: <20070517112357.7adc4763.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 17 May 2007 23:20:12 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> 
>>A meaningful container size does not hamper performance. I am in the process
>>of getting more results (with varying container sizes). Please let me know
>>what you think of the results? Would you like to see different benchmarks/
>>tests/configuration results?
>>
>>Any feedback, suggestions to move this work forward towards identifying
>>and correcting bottlenecks or to help improve it is highly appreciated.
> 
> 
> <wakes up>
> 
> Memory reclaim tends not to consume much CPU.  Because in steady state it
> tends to be the case that the memory reclaim rate (and hopefully the
> scanning rate) is equal to the disk IO rate.

> Often the most successful way to identify performance problems in there is
> by careful code inspection followed by development of exploits.
> 
> Is this RSS controller built on Paul's stuff, or is it standalone?
it is based on Paul's patches.
 
> Where do we stand on all of this now anyway?  I was thinking of getting Paul's
> changes into -mm soon, see what sort of calamities that brings about.
I think we can merge Paul's patches with *interfaces* and then switch to
developing/reviewing/commiting resource subsytems.
RSS control had good feedback so far from a number of people
and is a first candidate imho.

Thanks,
Kirill

