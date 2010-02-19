Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424Ab0BSFJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 00:09:37 -0500
Received: from mail-pz0-f192.google.com ([209.85.222.192]:36404 "EHLO
	mail-pz0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab0BSFJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 00:09:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=cjY6GWPhc+g0RRLOh12GPDtt98JRnaP48K6X18albYxpUNHWAynfiuVKrERI4Aw95Z
         nHzo/dFJvctMhs6vM1hgdWzmWBP47uPYOzLLj9MK3SjaaBzPaq5iuzyC88ETnC5tKCnT
         wLpCgVnlbiY/sqrijDz3S99qN2TM9o74hikmM=
MIME-Version: 1.0
In-Reply-To: <1266516162-14154-4-git-send-email-mel@csn.ul.ie>
References: <1266516162-14154-1-git-send-email-mel@csn.ul.ie>
	 <1266516162-14154-4-git-send-email-mel@csn.ul.ie>
Date: Fri, 19 Feb 2010 14:09:35 +0900
Message-ID: <28c262361002182109p67f7d221m9385b56e52b33f50@mail.gmail.com>
Subject: Re: [PATCH 03/12] mm: Share the anon_vma ref counts between KSM and 
	page migration
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
> For clarity of review, KSM and page migration have separate refcounts on
> the anon_vma. While clear, this is a waste of memory. This patch gets
> KSM and page migration to share their toys in a spirit of harmony.
>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

When I reviewed your patch [1/12], I thought like this.
Looks good to me.

-- 
Kind regards,
Minchan Kim
