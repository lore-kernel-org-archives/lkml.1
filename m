Return-Path: <linux-kernel-owner+w=401wt.eu-S1764805AbXJZV7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764805AbXJZV7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 17:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbXJZV7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 17:59:04 -0400
Received: from dvhart.com ([64.146.134.43]:48328 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbXJZV7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 17:59:03 -0400
Message-ID: <47226325.4000404@mbligh.org>
Date: Fri, 26 Oct 2007 14:59:01 -0700
From: Martin Bligh <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, marcelo@kvack.org,
       linux-kernel@vger.kernel.org, drepper@redhat.com, linux-mm@kvack.org
Subject: Re: OOM notifications
References: <20071018201531.GA5938@dmt>	<20071026140201.ae52757c.akpm@linux-foundation.org>	<472256AB.6060109@mbligh.org>	<20071026141112.18af0fa6.akpm@linux-foundation.org> <20071026173550.333d8eb4@bree.surriel.com>
In-Reply-To: <20071026173550.333d8eb4@bree.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> On Fri, 26 Oct 2007 14:11:12 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> Sure, but in terms of high-level userspace interface, being able to
>> select() on a group of priority buckets (spread across different
>> nodes, zones and cgroups) seems a lot more flexible than any
>> signal-based approach we could come up with.
> 
> Absolutely, the process needs to be able to just poll or
> select on a file descriptor from the process main loop.
> 
> I am not convinced that the magic of NUMA memory distribution
> and NUMA memory pressure should be visible to userspace.  Due
> to the thundering herd problem we cannot wake up all of the
> processes that select on the filedescriptor at the same time
> anyway, so we can (later on) add NUMA magic to the process
> selection logic in the kernel to only wake up processes on
> the right NUMA nodes.
> 
> The initial patch probably does not need that.

Depends if you're using cpusets or not, I think?

