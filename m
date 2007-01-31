Return-Path: <linux-kernel-owner+w=401wt.eu-S1161045AbXAaVhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161045AbXAaVhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 16:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161047AbXAaVhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 16:37:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161045AbXAaVhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 16:37:47 -0500
Message-ID: <45C10BDE.80801@redhat.com>
Date: Wed, 31 Jan 2007 16:36:30 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Ken Moffat <zarniwhoop@ntlworld.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: x86 instability with 2.6.1{8,9}
References: <20070101160158.GA26547@deepthought> <200701021225.57708.lenb@kernel.org> <20070102180425.GA18680@deepthought> <200701021342.32195.lenb@kernel.org> <20070102193459.GA19894@deepthought> <20070106140459.a6b72039.randy.dunlap@oracle.com> <20070107142641.GA30379@deepthought> <20070115162911.GA13198@deepthought> <20070125235627.GA17168@deepthought>
In-Reply-To: <20070125235627.GA17168@deepthought>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ken Moffat wrote:
> On Mon, Jan 15, 2007 at 04:29:11PM +0000, Ken Moffat wrote:
>   
>>  Today, I've built 2.6.19.2 without highmem (the box only has 1GB,
>> dunno why I'd included that in the original config) and I will
>> continue to wait patiently for either a week without problems, or
>> something that I can manage to note - although I think at the moment
>> that the second coming of the great prophet Zarquon is more likely.
>>
>>     
>  Bizarre - it panic'd again last Thursday while I was in X, but I
> still didn't manage to log any output.  At the weekend, I had the
> bright idea of using chattr +j on the syslog to try to journal any
> data, since then it has been fine.  So, it isn't down to highmem, and
> I still can't trigger it reliably, or get any trace.  Tried running
> as x86_64 this morning (because cold starts on Thursdays seem
> particularly problematic, perhaps it's a time/power-supply-noise
> problem), then x86 from a cold start this afternoon.
>
>  Time to hope it won't bite me too often, and move on to testing
> 2.6.20-rc6.
>
> Ken
>   
Try disabling preempt.

