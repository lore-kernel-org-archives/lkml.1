Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab0BSBfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 20:35:41 -0500
Received: from mail-px0-f191.google.com ([209.85.216.191]:50796 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab0BSBfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 20:35:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=iI7Ah0Tx5+9gpRZX5P/SJqAmKYReEl7cdRiC00uD5uVzVUXReYERbCSahpIRRNMIWE
         DV0Winb2J2lbmSugja80rRI46fAo1l0eMaCDrwNUeTRWU1pTQbSKWeYYjktO0Wyp0BZL
         af7BLYlhjdT0THtBBvbozued0dI/tlDY79TLs=
MIME-Version: 1.0
In-Reply-To: <1266516162-14154-7-git-send-email-mel@csn.ul.ie>
References: <1266516162-14154-1-git-send-email-mel@csn.ul.ie>
	 <1266516162-14154-7-git-send-email-mel@csn.ul.ie>
Date: Fri, 19 Feb 2010 10:35:38 +0900
Message-ID: <28c262361002181735w56ea868fmf778d3421bbecb31@mail.gmail.com>
Subject: Re: [PATCH 06/12] Export unusable free space index via 
	/proc/pagetypeinfo
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
> Unusuable free space index is a measure of external fragmentation that
> takes the allocation size into account. For the most part, the huge page
> size will be the size of interest but not necessarily so it is exported
> on a per-order and per-zone basis via /proc/unusable_index.
>
> The index is a value between 0 and 1. It can be expressed as a
> percentage by multiplying by 100 as documented in
> Documentation/filesystems/proc.txt.
>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
