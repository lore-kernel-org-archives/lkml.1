Return-Path: <linux-kernel-owner+w=401wt.eu-S1030220AbXCFVon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030220AbXCFVon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 16:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030224AbXCFVon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 16:44:43 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030220AbXCFVom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 16:44:42 -0500
Message-ID: <45EDE0B5.4060907@redhat.com>
Date: Tue, 06 Mar 2007 16:44:21 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>,
       bert hubert <bert.hubert@netherlabs.nl>, linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>	<45E9DD4A.2060806@redhat.com>	<20070303131204.6706a95c.akpm@linux-foundation.org>	<45E9E910.2070804@redhat.com>	<20070303214108.GA28961@outpost.ds9a.nl>	<20070303141448.1ed70e6d.akpm@linux-foundation.org>	<45E9F454.2080600@redhat.com>	<20070303142609.d3bc9cc3.akpm@linux-foundation.org>	<20070303230155.GA475@outpost.ds9a.nl>	<20070303154541.70aed9df.akpm@linux-foundation.org>	<45ED5A49.1010702@draigBrady.com> <20070306134046.5be821f5.akpm@linux-foundation.org>
In-Reply-To: <20070306134046.5be821f5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 06 Mar 2007 12:10:49 +0000
> P__draig Brady <P@draigBrady.com> wrote:
>> Andrew Morton wrote:

>> If I'm the target
>> audience for that API then it's broken as I'd mess it up,
>> or would take too long to get it right.
>>
>> Can't we just fix the posix_fadvise() implementation to
>> only evict pages paged in by the current process.
> 
> The kernel doesn't have that information.

It doesn't _keep_ the information.  File readahead is done
in the process context, so we had it originally.

I agree though that we probably should not bother trying
to keep that kind of information :)

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
