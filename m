Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbZHCOXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbZHCOXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 10:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755074AbZHCOXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 10:23:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53356 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755064AbZHCOXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 10:23:53 -0400
Message-ID: <4A76F27E.5070407@redhat.com>
Date: Mon, 03 Aug 2009 17:21:50 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 1/12] ksm: rename kernel_pages_allocated
References: <Pine.LNX.4.64.0908031304430.16449@sister.anvils> <Pine.LNX.4.64.0908031308590.16754@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0908031308590.16754@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> We're not implementing swapping of KSM pages in its first release;
> but when that follows, "kernel_pages_allocated" will be a very poor
> name for the sysfs file showing number of nodes in the stable tree:
> rename that to "pages_shared" throughout.
>
> But we already have a "pages_shared", counting those page slots
> sharing the shared pages: first rename that to... "pages_sharing".
>
> What will become of "max_kernel_pages" when the pages shared can
> be swapped?  I guess it will just be removed, so keep that name.
>
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> ---
>
>
>   
ACK.

