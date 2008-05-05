Return-Path: <linux-kernel-owner+w=401wt.eu-S1761474AbYEEUY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761474AbYEEUY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761487AbYEEUYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:24:10 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:13703 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761472AbYEEUYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:24:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=blEn5pSmFaph/Wz170UcF7jf7QqxC3eAAoIKrLahhEIf8tq/9z68iA+LmHFmtEr+SAxKnQFqoQM7L3GjkAXyJ1Snvp+6ltvKGGwQjmhUOqdCYg21RI1yANLxnWiL+OO2AYij5gPmFnkAVO0la07rdzLM5Kkhg+LObw9+QlL6y/Q=
Message-ID: <2f11576a0805051324r46d3ab03ybf14a289d9841cb6@mail.gmail.com>
Date: Tue, 6 May 2008 05:24:07 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] mm/page_alloc.c: cleanups
Cc: linux-kernel@vger.kernel.org, "Peter Zijlstra" <peterz@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080505182542.GS17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080505182542.GS17139@cs181133002.pp.htv.fi>
X-Google-Sender-Auth: dbefba76269a9755
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  -void free_cold_page(struct page *page)
>  -{
>  -       free_hot_cold_page(page, 1);
>  -}

Wow, I didn't know nobody use cold page :)
Of cource, you are right.

              Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
