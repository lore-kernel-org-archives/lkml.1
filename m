Return-Path: <linux-kernel-owner+w=401wt.eu-S1751202AbZG3NqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202AbZG3NqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 09:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbZG3NqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 09:46:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36894 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbZG3NqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 09:46:14 -0400
Message-ID: <4A71A3FD.6030802@redhat.com>
Date: Thu, 30 Jul 2009 09:45:33 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Larry Woodman <lwoodman@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] tracing, page-allocator: Add a postprocessing script
 for page-allocator-related ftrace events
References: <1248901551-7072-1-git-send-email-mel@csn.ul.ie> <1248901551-7072-5-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1248901551-7072-5-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> This patch adds a simple post-processing script for the page-allocator-related
> trace events. It can be used to give an indication of who the most
> allocator-intensive processes are and how often the zone lock was taken
> during the tracing period. Example output looks like
> 
> find-2840
>  o pages allocd            = 1877
>  o pages allocd under lock = 1817
>  o pages freed directly    = 9
>  o pcpu refills            = 1078
>  o migrate fallbacks       = 48
>    - fragmentation causing = 48
>      - severe              = 46
>      - moderate            = 2
>    - changed migratetype   = 7

I like it.

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
