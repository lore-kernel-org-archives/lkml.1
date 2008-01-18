Return-Path: <linux-kernel-owner+w=401wt.eu-S1761344AbYARM7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761344AbYARM7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 07:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757594AbYARM7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 07:59:13 -0500
Received: from relay1.sgi.com ([192.48.171.29]:33842 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757345AbYARM7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 07:59:12 -0500
Message-ID: <4790A29F.9000006@sgi.com>
Date: Fri, 18 Jan 2008 04:59:11 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: Reduce memory and intra-node effects with	large
 count NR_CPUs fixup
References: <20080117223546.419383000@sgi.com> <478FD9D9.7030009@sgi.com> <20080118092352.GH24337@elte.hu>
In-Reply-To: <20080118092352.GH24337@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Hi Andrew,
>>
>> My automatic scripts accidentally sent this mail prematurely.  Please 
>> hold off applying yet.
> 
> I've picked it up for x86.git and i'll keep testing it (the patches seem 
> straightforward) and will report any problems with the bite-head-off 
> option unset.
> 
> [ The 32-bit NUMA compile issue is orthogonal to these patches - it's 
>   due to the lack of 32-bit NUMA support in your changes :) That needs 
>   fixing before this could go into v2.6.25. ]
> 
> 	Ingo

I hadn't considered doing 32-bit NUMA changes as I didn't know if the
NR_CPUS count would really be increased for the 32-bit architecture.
I have been trying though not to break it. ;-)

Thanks,
Mike
