Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbYCKRF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbYCKRF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 13:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYCKRFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 13:05:17 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64836 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbYCKRFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 13:05:16 -0400
X-IronPort-AV: E=McAfee;i="5100,188,5249"; a="1219982"
Message-ID: <47D6BBC8.7090608@qualcomm.com>
Date: Tue, 11 Mar 2008 10:05:12 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: mingo@elte.hu, pj@sgi.com, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, menage@google.com
Subject: Re: [PATCH 1/2] cpuset: cpuset irq affinities
References: <1205215046-27085-1-git-send-email-maxk@qualcomm.com> <1205215046-27085-2-git-send-email-maxk@qualcomm.com> <20080311063514.GA29824@infradead.org>
In-Reply-To: <20080311063514.GA29824@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Christoph Hellwig wrote:
> On Mon, Mar 10, 2008 at 10:57:25PM -0700, maxk@qualcomm.com wrote:
>> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>>
>> Hi Paul,
>>
>> How about something like this; along with the in-kernel version
>> of /cgroup/boot this could also provide the desired semantics.
>>
>> Another benefit of this approach would be that it no longer requires
>> PF_THREAD_BIND, as we'd only stick unbounded kthreads into that cgroup.
> 
> Looks like my comments to the last posting of this are still not
> addressed.

Hi Christoph,

Sorry I missed your comment. Actually I just looked at the archive of the
original thread and I do not see any comments from you. Were they maybe sent
in private to Peter Z ? Can you please resend them ?

Also btw can you comment on the 2/2 patch of this series instead. 1/2 is just
a resend of the original Peter's patch. 2/2 is more complete and tested version.

Thanx
Max
