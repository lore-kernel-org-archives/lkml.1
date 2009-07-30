Return-Path: <linux-kernel-owner+w=401wt.eu-S1751152AbZG3NoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751152AbZG3NoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 09:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbZG3NoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 09:44:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36826 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbZG3NoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 09:44:11 -0400
Message-ID: <4A71A37B.3030306@redhat.com>
Date: Thu, 30 Jul 2009 09:43:23 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Larry Woodman <lwoodman@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] tracing, page-allocator: Add trace event for page
 traffic related to the buddy lists
References: <1248901551-7072-1-git-send-email-mel@csn.ul.ie> <1248901551-7072-4-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1248901551-7072-4-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> The page allocation trace event reports that a page was successfully allocated
> but it does not specify where it came from. When analysing performance,
> it can be important to distinguish between pages coming from the per-cpu
> allocator and pages coming from the buddy lists as the latter requires the
> zone lock to the taken and more data structures to be examined.

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
