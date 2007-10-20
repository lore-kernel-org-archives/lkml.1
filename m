Return-Path: <linux-kernel-owner+w=401wt.eu-S965618AbXJTBt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965618AbXJTBt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 21:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbXJTBtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 21:49:49 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:57760
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbXJTBts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 21:49:48 -0400
Date: Fri, 19 Oct 2007 18:53:55 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Phillip Susi <psusi@cfl.rr.com>
cc: "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH 0/2 -mm] kexec based hibernation -v5
In-Reply-To: <47190B28.6070405@cfl.rr.com>
Message-ID: <Pine.LNX.4.64.0710191852560.1538@asgard.lang.hm>
References: <1192068833.27482.13.camel@caritas-dev.intel.com>
 <47190B28.6070405@cfl.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007, Phillip Susi wrote:

> Huang, Ying wrote:
>> 
>> 
>> The restore process with the patch set is as follow:
>> 
>> 1. Boot a kernel C (crash dump enabled), the memory area used by
>>    kernel C must be a subset of memory area used by kernel B.
>
> Why is a third kernel needed?  Why can't kernel B be used for this as well? 
> In fact, if kernel A has been compiled to be relocatable and crash dump 
> enabled, why wouldn't it suffice for all 3 instances?

you could use one kernel for all three, or you could use three different 
kernels, and three different sets of userspace if it's appropriate.

David Lang
