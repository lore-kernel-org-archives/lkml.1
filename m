Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab0BREKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 23:10:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804Ab0BREKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 23:10:39 -0500
Message-ID: <4B7CBD71.2040709@redhat.com>
Date: Wed, 17 Feb 2010 23:09:21 -0500
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
Subject: Re: [PATCH 09/12] Do not compact within a preferred zone after a
 compaction failure
References: <1265976059-7459-1-git-send-email-mel@csn.ul.ie> <1265976059-7459-10-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1265976059-7459-10-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2010 07:00 AM, Mel Gorman wrote:
> The fragmentation index may indicate that a failure it due to external
> fragmentation, a compaction run complete and an allocation failure still
> fail. There are two obvious reasons as to why
>
>    o Page migration cannot move all pages so fragmentation remains
>    o A suitable page may exist but watermarks are not met
>
> In the event of compaction and allocation failure, this patch prevents
> compaction happening for a short interval. It's only recorded on the
> preferred zone but that should be enough coverage. This could have been
> implemented similar to the zonelist_cache but the increased size of the
> zonelist did not appear to be justified.
>
> Signed-off-by: Mel Gorman<mel@csn.ul.ie>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
