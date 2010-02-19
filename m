Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab0BSQpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 11:45:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925Ab0BSQpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 11:45:36 -0500
Message-ID: <4B7EC013.5090704@redhat.com>
Date: Fri, 19 Feb 2010 11:45:07 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 02/12] mm,migration: Do not try to migrate unmapped anonymous
 pages
References: <1266516162-14154-1-git-send-email-mel@csn.ul.ie> <1266516162-14154-3-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1266516162-14154-3-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2010 01:02 PM, Mel Gorman wrote:
> rmap_walk_anon() was triggering errors in memory compaction that looks like
> use-after-free errors in anon_vma. The problem appears to be that between
> the page being isolated from the LRU and rcu_read_lock() being taken, the
> mapcount of the page dropped to 0 and the anon_vma was freed. This patch
> skips the migration of anon pages that are not mapped by anyone.
>
> Signed-off-by: Mel Gorman<mel@csn.ul.ie>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
