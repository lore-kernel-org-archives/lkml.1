Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab0BSB7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 20:59:46 -0500
Received: from mail-px0-f191.google.com ([209.85.216.191]:37207 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab0BSB7p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 20:59:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vpg20YBOEIhG2Qdo5RWrHSu7tHE4AteGJV3PJSyIoDUbQBDaBnB+GzDIaNxCgTRPxb
         pkLgEKrFTHYQsNDLLJPk7SVtJ6iiBOQeD031aDG060EThnHp4ELwmUCP2ptSt4OU6FcH
         57AsVM0LJgw1czjZBTvwmTRu1UWybBy6jw3OM=
MIME-Version: 1.0
In-Reply-To: <1266516162-14154-8-git-send-email-mel@csn.ul.ie>
References: <1266516162-14154-1-git-send-email-mel@csn.ul.ie>
	 <1266516162-14154-8-git-send-email-mel@csn.ul.ie>
Date: Fri, 19 Feb 2010 10:59:45 +0900
Message-ID: <28c262361002181759m35c0fd73k5f252953b4d0932@mail.gmail.com>
Subject: Re: [PATCH 07/12] Export fragmentation index via /proc/pagetypeinfo
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 19, 2010 at 3:02 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> Fragmentation index is a value that makes sense when an allocation of a
> given size would fail. The index indicates whether an allocation failure is
> due to a lack of memory (values towards 0) or due to external fragmentation
> (value towards 1).  For the most part, the huge page size will be the size
> of interest but not necessarily so it is exported on a per-order and per-zone
> basis via /proc/pagetypeinfo.
>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
