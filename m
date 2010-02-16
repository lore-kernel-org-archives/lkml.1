Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199Ab0BPSaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 13:30:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932334Ab0BPSaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 13:30:05 -0500
Message-ID: <4B7AE3D9.9040504@redhat.com>
Date: Tue, 16 Feb 2010 13:28:41 -0500
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
Subject: Re: [PATCH 03/12] Export unusable free space index via /proc/pagetypeinfo
References: <1265976059-7459-1-git-send-email-mel@csn.ul.ie> <1265976059-7459-4-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1265976059-7459-4-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2010 07:00 AM, Mel Gorman wrote:
> Unusuable free space index is a measure of external fragmentation that
> takes the allocation size into account. For the most part, the huge page
> size will be the size of interest but not necessarily so it is exported
> on a per-order and per-zone basis via /proc/pagetypeinfo.
>
> The index is normally calculated as a value between 0 and 1 which is
> obviously unsuitable within the kernel. Instead, the first three decimal
> places are used as a value between 0 and 1000 for an integer approximation.
>
> Signed-off-by: Mel Gorman<mel@csn.ul.ie>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
