Return-Path: <linux-kernel-owner+w=401wt.eu-S1751562AbZH1NuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbZH1NuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 09:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbZH1NuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 09:50:00 -0400
Received: from mail-yw0-f184.google.com ([209.85.211.184]:61860 "EHLO
	mail-yw0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbZH1Nt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 09:49:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fElvmC0LyFitiBAOW9yTbH7SjWowoCWRYMPx7MoFwBNNq6ZjOIk4RpYVXDL5N3hgVN
         7XAMFjOfRUHqfzfpo4x21kOUk4zv7wl+ckB41vpY5ENJkiMY/CLAae4r72rW0biyg/Si
         ScfaZdpKIjSW1PZc5l7CZTj/cpqWAa9TaGpig=
MIME-Version: 1.0
In-Reply-To: <1251449067-3109-3-git-send-email-mel@csn.ul.ie>
References: <1251449067-3109-1-git-send-email-mel@csn.ul.ie>
	 <1251449067-3109-3-git-send-email-mel@csn.ul.ie>
Date: Fri, 28 Aug 2009 22:49:59 +0900
Message-ID: <28c262360908280649j2920445ekf5625eb0e86752a4@mail.gmail.com>
Subject: Re: [PATCH 2/2] page-allocator: Maintain rolling count of pages to 
	free from the PCP
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 28, 2009 at 5:44 PM, Mel Gorman<mel@csn.ul.ie> wrote:
> When round-robin freeing pages from the PCP lists, empty lists may be
> encountered. In the event one of the lists has more pages than another,
> there may be numerous checks for list_empty() which is undesirable. This
> patch maintains a count of pages to free which is incremented when empty
> lists are encountered. The intention is that more pages will then be freed
> from fuller lists than the empty ones reducing the number of empty list
> checks in the free path.
>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

I like this idea. :)
