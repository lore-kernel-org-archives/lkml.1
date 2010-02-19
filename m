Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab0BSQoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 11:44:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab0BSQoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 11:44:19 -0500
Message-ID: <4B7EBFB8.40904@redhat.com>
Date: Fri, 19 Feb 2010 11:43:36 -0500
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
Subject: Re: [PATCH 01/12] mm,migration: Take a reference to the anon_vma
 before migrating
References: <1266516162-14154-1-git-send-email-mel@csn.ul.ie> <1266516162-14154-2-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1266516162-14154-2-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2010 01:02 PM, Mel Gorman wrote:
> rmap_walk_anon() does not use page_lock_anon_vma() for looking up and
> locking an anon_vma and it does not appear to have sufficient locking to
> ensure the anon_vma does not disappear from under it.
>
> This patch copies an approach used by KSM to take a reference on the
> anon_vma while pages are being migrated. This should prevent rmap_walk()
> running into nasty surprises later because anon_vma has been freed.
>
> Signed-off-by: Mel Gorman<mel@csn.ul.ie>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
