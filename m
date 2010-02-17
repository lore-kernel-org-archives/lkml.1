Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab0BQQb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 11:31:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157Ab0BQQb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 11:31:28 -0500
Message-ID: <4B7C19A7.5010108@redhat.com>
Date: Wed, 17 Feb 2010 11:30:31 -0500
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
Subject: Re: [PATCH 07/12] Add /sys trigger for per-node memory compaction
References: <1265976059-7459-1-git-send-email-mel@csn.ul.ie> <1265976059-7459-8-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1265976059-7459-8-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2010 07:00 AM, Mel Gorman wrote:
> This patch adds a per-node sysfs file called compact. When the file is
> written to, each zone in that node is compacted. The intention that this
> would be used by something like a job scheduler in a batch system before
> a job starts so that the job can allocate the maximum number of
> hugepages without significant start-up cost.
>
> Signed-off-by: Mel Gorman<mel@csn.ul.ie>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
