Return-Path: <linux-kernel-owner+w=401wt.eu-S1760387AbYEEU7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760387AbYEEU7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbYEEU7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:59:36 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:32662 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbYEEU7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:59:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=OustEOf3uhddcQcI+ZRC2XwmsWaK6lvlFyHnGjT7WRZ7V/XXrpC2+GNw9TmPHQ3dgoh9+dHoebRJ0EBogf7DcYvAEFwHGbxTqiGYO7TvT/0Zcgp+ZuxPtdmvLFzLyqyoTszsUImoiCS8+g1LSdXYhis1cB/1fJwgYzFuuZvP8cA=
Message-ID: <2f11576a0805051359g7614f5f1l9d184539c715fff4@mail.gmail.com>
Date: Tue, 6 May 2008 05:59:31 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] mm/page_alloc.c: cleanups
Cc: bunk@kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org
In-Reply-To: <20080505134509.2c8a9b94.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080505182542.GS17139@cs181133002.pp.htv.fi>
	 <2f11576a0805051324r46d3ab03ybf14a289d9841cb6@mail.gmail.com>
	 <20080505134509.2c8a9b94.akpm@linux-foundation.org>
X-Google-Sender-Auth: c6defa57acfc1c73
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  > >  -void free_cold_page(struct page *page)
>  > >  -{
>  > >  -       free_hot_cold_page(page, 1);
>  > >  -}
>  >
>  > Wow, I didn't know nobody use cold page :)
>
>  that's a bug, surely?  I bet there are plenty of places which should be
>  using this hint.

Hm, as far as I investigate

1. nobody used free_cold_page() in kernel code tree.
2. free_cold_page() doesn't exported.

I investigated to 2.6.25-mm1.
I don't understand yet why you think plenty....
