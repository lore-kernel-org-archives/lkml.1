Return-Path: <linux-kernel-owner+w=401wt.eu-S1752936AbZEJXoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbZEJXoh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 19:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbZEJXo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 19:44:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45276 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbZEJXo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 19:44:28 -0400
Message-ID: <4A07666B.5020706@redhat.com>
Date: Sun, 10 May 2009 19:42:35 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mmotm] mm: invoke oom killer for __GFP_NOFAIL
References: <alpine.DEB.2.00.0905091544470.6884@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0905091544470.6884@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> The oom killer must be invoked regardless of the order if the allocation
> is __GFP_NOFAIL, otherwise it will loop forever when reclaim fails to
> free some memory.
> 
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Nick Piggin <npiggin@suse.de>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Dave Hansen <dave@linux.vnet.ibm.com>
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
