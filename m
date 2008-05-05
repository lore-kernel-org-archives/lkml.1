Return-Path: <linux-kernel-owner+w=401wt.eu-S1760035AbYEEUFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760035AbYEEUFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbYEEUFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:05:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:14039 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbYEEUFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:05:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=KRDptwxnn8zjzCllhtz6dIMatt6b95rLqZNwxjVOLt0uin1oET5B8sa70nhbii7SJXDfSalu+IQMLt6SgWZbeJVv5EhHpT6MFwHtKw0KU19OTO4I3mPMZFaKO6OU24KUs0Ip6ti5G2iEked8ZorHHmY5y2pUd1T3HCKzcSIjUMY=
Message-ID: <2f11576a0805051305q9a79558rf26eb80b73b5101c@mail.gmail.com>
Date: Tue, 6 May 2008 05:05:39 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] make mm/rmap.c:anon_vma_cachep static
Cc: "Rik van Riel" <riel@redhat.com>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080505182712.GI17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080505182712.GI17139@cs181133002.pp.htv.fi>
X-Google-Sender-Auth: ae0d9eb5a4cb503c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch makes the needlessly global anon_vma_cachep static.
>
>  Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
>  ---
>
>  This patch has been sent on:
>  - 22 Apr 2008
>  - 14 Apr 2008
>  - 31 Mar 2008
>  - 25 Feb 2008

definitely right change, I think.
I wonder why this patch is needed 5 times posting.

       Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
