Return-Path: <linux-kernel-owner+w=401wt.eu-S932169AbZHCOg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbZHCOg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 10:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932133AbZHCOg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 10:36:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35451 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932123AbZHCOg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 10:36:28 -0400
Message-ID: <4A76F57A.7090805@redhat.com>
Date: Mon, 03 Aug 2009 17:34:34 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 2/12] ksm: move pages_sharing updates
References: <Pine.LNX.4.64.0908031304430.16449@sister.anvils> <Pine.LNX.4.64.0908031310060.16754@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0908031310060.16754@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> The pages_shared count is incremented and decremented when adding a node
> to and removing a node from the stable tree: easy to understand.  But the
> pages_sharing count was hard to follow, being adjusted in various places:
> increment and decrement it when adding to and removing from the stable tree.
>
> And the pages_sharing variable used to include the pages_shared, then those
> were subtracted when shown in the pages_sharing sysfs file: now keep it as
> an exclusive count of leaves hanging off the stable tree nodes, throughout.
>
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> ---
>
>   
ACK, (Code is simpler that way)
