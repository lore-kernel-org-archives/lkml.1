Return-Path: <linux-kernel-owner+w=401wt.eu-S1765020AbYEHQnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765020AbYEHQnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 12:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764799AbYEHQmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 12:42:40 -0400
Received: from rn-out-0910.google.com ([64.233.170.184]:4326 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764762AbYEHQmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 12:42:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cAWZBk6pLwSdODgY5RSobd8enKRz6V+nGQGiyhiqAsDbtiSykFQISW+wVG5XNlzxl9hVNDoDBi9xgkvYec6KRqK9t7NPk8g8BSABk2AxY6LNj0ST8FQrzkSxa/2fV6FNCWTjsKhWJYQZcV481mlV9dGIigNm16/UvO3WyI8zQHs=
Message-ID: <7c86c4470805080942v4b3c17a7jacf5e14eb21b1345@mail.gmail.com>
Date: Thu, 8 May 2008 08:42:35 -0800
From: "stephane eranian" <eranian@googlemail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] perfmon: add context switch hooks for x86
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, tglx@linutronix.de
In-Reply-To: <4821BD2A.3090000@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470805070133q29515056s386c137f644b7f3b@mail.gmail.com>
	 <4821BA06.9020704@firstfloor.org>
	 <7c86c4470805070724v793fbdcamf18579308a183a9d@mail.gmail.com>
	 <4821BD2A.3090000@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

It is not necessarily that easy. I will lok at this next week.

On 5/7/08, Andi Kleen <andi@firstfloor.org> wrote:
> stephane eranian wrote:
>  > Andi,
>  >
>  > It would be much bigger because it would pull in a bunch of generic
>  > and model-specific
>  > data structures and code.
>  >
>  > To context switch, you need to know what the registers are, thus you
>  > need the PMU
>  > mapping table, which is implemented by a kernel module, so it needs
>  > its registration
>  > framework....
>
>
> Can you strip it down to be simpler?
>
>  Minimally generic x86 perfctr switching code just needs an array with
>  MSR numbers, doesn't it? And there are only a few variants.
>
>
>  -Andi
>
