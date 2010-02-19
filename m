Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab0BSC0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 21:26:51 -0500
Received: from mail-pz0-f192.google.com ([209.85.222.192]:35877 "EHLO
	mail-pz0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab0BSC0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 21:26:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UkcdhEVUrAJkmd4k+KWwCgJIQzKuC+3tj8azN+elTDpZk3zwKag24FiqElgqlKh6n2
         qkRp2Dt3UzTnrwxaO5thapSINmx8A6Dv5hEqpD1XQALw+2Lj9Hoqe+o1Q9lBvRT7TmO/
         spAWBFUKHxY3tveVQ8WRk8aR2YKSGjqAuzuKE=
MIME-Version: 1.0
In-Reply-To: <1266516162-14154-10-git-send-email-mel@csn.ul.ie>
References: <1266516162-14154-1-git-send-email-mel@csn.ul.ie>
	 <1266516162-14154-10-git-send-email-mel@csn.ul.ie>
Date: Fri, 19 Feb 2010 11:26:48 +0900
Message-ID: <28c262361002181826i56149952xb08bf9fe39c58f65@mail.gmail.com>
Subject: Re: [PATCH 09/12] Add /proc trigger for memory compaction
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 19, 2010 at 3:02 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> This patch adds a proc file /proc/sys/vm/compact_memory. When an arbitrary
> value is written to the file, all zones are compacted. The expected user
> of such a trigger is a job scheduler that prepares the system before the
> target application runs.
>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>



-- 
Kind regards,
Minchan Kim
