Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933138Ab0BPRnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 12:43:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199Ab0BPRnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 12:43:49 -0500
Message-ID: <4B7AD92C.6050802@redhat.com>
Date: Tue, 16 Feb 2010 12:43:08 -0500
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
Subject: Re: [PATCH 02/12] Allow CONFIG_MIGRATION to be set without CONFIG_NUMA
 or memory hot-remove
References: <1265976059-7459-1-git-send-email-mel@csn.ul.ie> <1265976059-7459-3-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1265976059-7459-3-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2010 07:00 AM, Mel Gorman wrote:
> CONFIG_MIGRATION currently depends on CONFIG_NUMA or on the architecture
> being able to hot-remove memory. The main users of page migration such as
> sys_move_pages(), sys_migrate_pages() and cpuset process migration are
> only beneficial on NUMA so it makes sense.
>
> As memory compaction will operate within a zone and is useful on both NUMA
> and non-NUMA systems, this patch allows CONFIG_MIGRATION to be set if the
> user selects CONFIG_COMPACTION as an option.
>
> Signed-off-by: Mel Gorman<mel@csn.ul.ie>
> Reviewed-by: Christoph Lameter<cl@linux-foundation.org>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
