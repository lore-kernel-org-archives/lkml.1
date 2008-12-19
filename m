Return-Path: <linux-kernel-owner+w=401wt.eu-S1752986AbYLSDKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbYLSDKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 22:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYLSDKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 22:10:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41007 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbYLSDK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 22:10:29 -0500
Message-ID: <494B1092.1020600@redhat.com>
Date: Thu, 18 Dec 2008 22:10:10 -0500
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       sfr@canb.auug.org.au, trond.myklebust@fys.uio.no, steved@redhat.com,
       bfields@fieldses.org, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Pull request for FS-Cache, including NFS patches
References: <20081218123601.11810b7f.akpm@linux-foundation.org>	<8930.1229560221@redhat.com>	<20081218224418.804f10bc.sfr@canb.auug.org.au>	<20081218142420.GA16728@infradead.org>	<7633.1229653644@redhat.com> <20081218184443.d73f5431.akpm@linux-foundation.org>
In-Reply-To: <20081218184443.d73f5431.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 19 Dec 2008 02:27:24 +0000 David Howells <dhowells@redhat.com> wrote:
>
>   
>>> Are any distros pushing for this?  Or shipping it?  If so, are they
>>> able to weigh in and help us with this quite difficult decision?
>>>       
>> We (Red Hat) have shipped it in RHEL-5 and some Fedora releases.  Doing so is
>> quite an effort, though, precisely because the code is not yet upstream.  We
>> have customers using it and are gaining more customers who want it.  There
>> even appear to be CentOS users using it (or at least complaining when it
>> breaks).
>>     
>
> That's useful news.
>   

The users that I spoke to from the financial sector that tried it are 
still quite interested. One simple use case for them is a very large 
cluster of NFS clients for read-mostly workloads (say, 1000 or more NFS 
clients for shared system partitions). They like the ability to do 
persistent caching across reboots which allows them to have less (and 
less beefy) NFS servers for all of those boxes trying to reboot at once.

The other use case was for the large rendering customers, but I don't 
have first hand knowledge of the details...

Regards,

Ric

