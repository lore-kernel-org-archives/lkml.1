Return-Path: <linux-kernel-owner+w=401wt.eu-S1761059AbYEEULe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761059AbYEEULe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760201AbYEEULO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:11:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:27423 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759628AbYEEULM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:11:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=fIF5wPOTlqwpUDgOWfzZ+sawsg1QX9x+UEOYqmGTE2JXjszR6QAEidoqnj6tn3/+Bgobn2FOZrHcZ2tvOrTuZsUEeBXIeei3nACWLhkH5mqnSZD00fWyYRs+Htu3cdttUAqkwZP725awU4dBfPfttsIAtQ5JX7n8osJ7GnXkoAQ=
Message-ID: <2f11576a0805051311m60c0dfb5k56c04d5f4ddc04e8@mail.gmail.com>
Date: Tue, 6 May 2008 05:11:10 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] mm/hugetlb.c: fix duplicate variable
Cc: wli@holomorphy.com, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080505182816.GN17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080505182816.GN17139@cs181133002.pp.htv.fi>
X-Google-Sender-Auth: a8a310465c96fff4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's confusing that set_max_huge_pages() contained two different
>  variables named "ret", and although the code works correctly this should
>  be fixed.
>
>  The inner of the two variables can simply be removed.
                            ^^^^

two?
I think removal inner variable is 1, no?
but, your change is perfectly right, IMHO.

           Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


>         while (count > persistent_huge_pages) {
>  -               int ret;
>                 /*
>                  * If this allocation races such that we no longer need the
>                  * page, free_huge_page will handle it by freeing the page
>                  * and reducing the surplus.
>                  */
